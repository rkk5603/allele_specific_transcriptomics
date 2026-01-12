#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
DIR_ALIGN_FILTERED=$2
DIR_INDEX=$3
DIR_VARIANTS=$4

#for haploid parent variants
samtools index ${DIR_ALIGN_FILTERED}/${FILE}_dedup.bam
echo ${FILE}_dedup.bam indexed

freebayes \
	-p 1 -f ${DIR_INDEX}/Amel_HAv3.1.fasta \
	${DIR_ALIGN_FILTERED}/${FILE}_dedup.bam > ${DIR_VARIANTS}/${FILE}.vcf
echo ${FILE} finished
