#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
THREADS=$2
DIR_INDEX=$3
DIR_PARENT_GENOMES=$4

# This step assembles F1 transcriptomes using the gtf file retrieved from the F1 RNA seq run.
# The constructed F1.fasta genomes are compared to a reference gtf to determine which genomic regions
# are exons and code for transcripts, allowing for assembly of F1 transcriptomes
STAR \
	--runThreadN ${THREADS} \
	--runMode genomeGenerate \
	--genomeDir ${DIR_PARENT_GENOMES}/${FILE} \
	--genomeFastaFiles ${DIR_PARENT_GENOMES}/${FILE}_fixed.fasta \
	--sjdbGTFfile ${DIR_INDEX}/Amel_HAv3.1.gtf

echo ${FILE} transcriptome assembled
echo finished
