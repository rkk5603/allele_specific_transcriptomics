#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
DIR_INDEX=$2
DIR_PARENT_GENOMES=$3
DIR_VARIANTS_FILTERED=$4

# Integrates SNPs from each parent into reference genome to create individual genomes
gatk FastaAlternateReferenceMaker \
	-R ${DIR_INDEX}/Amel_HAv3.1.fasta \
	-O ${DIR_PARENT_GENOMES}/${FILE}.fasta \
	-V ${DIR_VARIANTS_FILTERED}/${FILE}_homozygous_snps.vcf.gz

echo ${FILE}.fasta alternate reference generated
