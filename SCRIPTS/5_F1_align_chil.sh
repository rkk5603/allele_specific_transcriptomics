#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
THREADS=$2
DIR_ALIGN=$3
DIR_INDEX=$4
DIR_TRIM=$5

# run bwa alignment
# filtter out low quality alignments with default threshold (-t)
bwa mem \
	-t ${THREADS} \
	${DIR_INDEX}/Amel_HAv3.1.fasta \
	${DIR_TRIM}/${FILE}_1.fastq ${DIR_TRIM}/${FILE}_2.fastq \
	> ${DIR_ALIGN}/${FILE}.sam
echo ${FILE} aligned

# Remove alignments with any flags in 2316
# Convert SAM to BAM and sort using 500Mb memory per thread (4Gb was too much)
samtools view \
	-@ ${THREADS} -F 2316 -O bam ${DIR_ALIGN}/${FILE}.sam \
	| samtools sort -@ ${THREADS} -m 500M -O bam - \
	> ${DIR_ALIGN}/${FILE}.bam
echo ${FILE}.bam generated
