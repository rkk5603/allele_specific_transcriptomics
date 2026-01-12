#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
DIR_VARIANTS_FILTERED=$2
DIR_VARIANTS=$3
QUAL=$4
MINDP=$5
MAXDP=$6

# Remove variants that do not meet criteria
# Retain only high-quality homozygous SNPs
vcftools \
	--vcf ${DIR_VARIANTS}/${FILE}.vcf \
	--minQ ${QUAL} \
	--min-meanDP ${MINDP} --max-meanDP ${MAXDP} \
	--minDP ${MINDP} --maxDP ${MAXDP} \
	--recode --stdout \
	| bcftools filter -e 'GT="het"' - \
	| bcftools filter -i 'TYPE="snp"' - \
	> ${DIR_VARIANTS_FILTERED}/${FILE}_homozygous_snps.vcf

echo ${FILE} variants filtered

# Compress
bgzip -c ${DIR_VARIANTS_FILTERED}/${FILE}_homozygous_snps.vcf \
	> ${DIR_VARIANTS_FILTERED}/${FILE}_homozygous_snps.vcf.gz

# Index the compressed file
tabix -p vcf ${DIR_VARIANTS_FILTERED}/${FILE}_homozygous_snps.vcf.gz

echo ${FILE} vcf compressed and indexed
