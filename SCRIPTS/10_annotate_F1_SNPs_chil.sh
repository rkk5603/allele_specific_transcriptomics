#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# The high-quality homozygous SNPs for each cross are intersected to find those that are unique to each parent but shared between the crosses. This target does three things:
# First, the Amel_HAv3.1 reference genome feature file (gff) is subset to gene features, and column 9 (the info column) is used to keep only the RefSeq GeneID (these will be
#used in all downstream analyses).
DIR_INDEX=$1
DIR_VARIANTS_FILTERED=$2
DIR_ANALYSIS=$3
REF=$4
CrossApat=$5
CrossAmat=$6
CrossBpat=$7
CrossBmat=$8
BLOCK=$9

# Subset Amel_HAv3.1.gff to rows with "gene"" in column 3
# Print columns 1-8
awk '$3 == "gene" { print $0 }' ${DIR_INDEX}/${REF}.gff \
	| awk -v OFS="\t" '{print $1, $2, $3, $4, $5, $6, $7, $8}' \
	> ${DIR_INDEX}/${REF}_genes.txt
echo ${REF}_genes.txt generated

# Extract the "GeneID" from column 9
awk '$3 == "gene" { print $0 }' ${DIR_INDEX}/${REF}.gff \
	| awk '{print $9}' \
	| grep -o 'GeneID[^\s]*' \
	| cut -d':' -f2 \
	| cut -d';' -f1 \
	| cut -d',' -f1 \
	| sed -e 's/^/LOC/' \
	> ${DIR_INDEX}/${REF}_geneIDs.txt
echo ${REF}_geneIDs.txt generated

# Combine the two files to create a new gene-only .gff
paste -d'\t' ${DIR_INDEX}/${REF}_genes.txt \
	${DIR_INDEX}/${REF}_geneIDs.txt \
	> ${DIR_INDEX}/${REF}_genes.gff3
echo ${REF}_genes.gff3 generated


# Then informative SNPs are identified by taking the difference of each respective parental SNP call set (i.e., SNPs unique to each parent) and
#finding the intersection between crosses.

# Get SNPs in -a that are not in -b
bedtools intersect -header -v \
	-a ${DIR_VARIANTS_FILTERED}/${CrossApat}_homozygous_snps.vcf \
	-b ${DIR_VARIANTS_FILTERED}/${CrossAmat}_homozygous_snps.vcf \
	> ${DIR_VARIANTS_FILTERED}/${CrossApat}_homozygous_snps_outer.vcf

bedtools intersect -header -v \
	-a ${DIR_VARIANTS_FILTERED}/${CrossAmat}_homozygous_snps.vcf \
	-b ${DIR_VARIANTS_FILTERED}/${CrossApat}_homozygous_snps.vcf \
	> ${DIR_VARIANTS_FILTERED}/${CrossAmat}_homozygous_snps_outer.vcf

bedtools intersect -header -v \
	-a ${DIR_VARIANTS_FILTERED}/${CrossBpat}_homozygous_snps.vcf \
	-b ${DIR_VARIANTS_FILTERED}/${CrossBmat}_homozygous_snps.vcf \
	> ${DIR_VARIANTS_FILTERED}/${CrossBpat}_homozygous_snps_outer.vcf

bedtools intersect -header -v \
	-a ${DIR_VARIANTS_FILTERED}/${CrossBmat}_homozygous_snps.vcf \
	-b ${DIR_VARIANTS_FILTERED}/${CrossBpat}_homozygous_snps.vcf \
	> ${DIR_VARIANTS_FILTERED}/${CrossBmat}_homozygous_snps_outer.vcf

echo informative SNPs identified
echo shit load of vcf files generated

# Combine Cross A SNPs from above to single .vcf
grep -v '^#' \
	${DIR_VARIANTS_FILTERED}/${CrossApat}_homozygous_snps_outer.vcf \
	| cat ${DIR_VARIANTS_FILTERED}/${CrossAmat}_homozygous_snps_outer.vcf - \
	> ${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossA_homozygous_snps_outer.vcf
 
# Compress the combined Cross A .vcf
bgzip -c \
	${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossA_homozygous_snps_outer.vcf \
	> ${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossA_homozygous_snps_outer.vcf.gz
echo Cross A vcf files merged and compressed

# Combine Cross B SNPs from above to single .vcf
grep -v '^#' \
	${DIR_VARIANTS_FILTERED}/${CrossBpat}_homozygous_snps_outer.vcf \
	| cat ${DIR_VARIANTS_FILTERED}/${CrossBmat}_homozygous_snps_outer.vcf - \
	> ${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossB_homozygous_snps_outer.vcf

# Compress the combined Cross B .vcf
bgzip -c \
	${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossB_homozygous_snps_outer.vcf \
	> ${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossB_homozygous_snps_outer.vcf.gz
echo Cross B vcf files merged and compressed

# Intersect the combined Cross A & Cross B SNPs
bedtools intersect -header -u \
	-a ${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossA_homozygous_snps_outer.vcf.gz \
	-b ${DIR_VARIANTS_FILTERED}/${BLOCK}_CrossB_homozygous_snps_outer.vcf.gz \
	> ${DIR_ANALYSIS}/${BLOCK}_Analysis_SNP_Set.vcf

# Create a basic .bed file from the intersected SNPs
# Use the genomic position as the start and end coordinates
# Label each variant sequentially (i.e., SNP_1, SNP_2, etc.)
grep -v '^#' ${DIR_ANALYSIS}/${BLOCK}_Analysis_SNP_Set.vcf \
	| awk -v OFS="\t" '{print $1, $2, $2}' \
	| awk -v OFS="\t" '$4=(FNR FS $4)' \
	| awk -v OFS="\t" '{print $1, $2, $3, "snp_"$4}' \
	> ${DIR_ANALYSIS}/${BLOCK}_Analysis_SNP_Set.bed
echo Cross A and Cross B SNPs interesected
echo Generated bed file

# Finally, the script annotates the genes with the positions of informative F1 SNPs. These SNPs will be later subset to those within the
#longest transcript for each gene. Mitochondrial genes (on the chromosome with nucleotide accession  ^`^|NC_001566.1 ^`^}) are filtered, as these are innapropriate for assessing
#parent-of-origin effects (as all mitochondrial genes will be maternally expressed).


# Intersect the gene annotations and SNP set
# Combine the SNP_ID and GeneIDs in column 4 (name) as SNP_ID:GeneID
bedtools intersect -wb \
	-a ${DIR_INDEX}/${REF}_genes.gff3 \
	-b ${DIR_ANALYSIS}/${BLOCK}_Analysis_SNP_Set.bed \
	| awk -v OFS="\t" '{print $10, $11, $12, $13 ":" $9, $6, $7}' \
	| grep -v '^NC_001566.1' | sort -k1,1 -k2,2n \
	> ${DIR_ANALYSIS}/${BLOCK}_SNPs_for_Analysis.bed

sort --parallel=8 -k1,1 -k2,2n \
	${DIR_ANALYSIS}/${BLOCK}_SNPs_for_Analysis.bed \
	> ${DIR_ANALYSIS}/${BLOCK}_SNPs_for_Analysis_Sorted.bed
echo SNPs annotated and sorted
echo Generated SNPs_for_Analysis_Sorted.bed
echo Finished
