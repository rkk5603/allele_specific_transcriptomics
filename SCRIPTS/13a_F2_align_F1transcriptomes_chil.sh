#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
DIR_TRIM=$2
DIR_PARENT_GENOMES=$3
DIR_ALIGN=$4
DIR_INDEX=$5
THREADS=$6
CrossApat=$7
CrossAmat=$8
REF=$9

# Aligns F2 reads to F1 drone
STAR \
	--outSAMtype BAM SortedByCoordinate \
	--runThreadN ${THREADS} \
	--sjdbGTFfile ${DIR_INDEX}/${REF}.gtf \
	--genomeDir ${DIR_PARENT_GENOMES}/${CrossApat} \
	--readFilesIn ${DIR_TRIM}/${FILE}_1.fastq ${DIR_TRIM}/${FILE}_2.fastq \
	--outFileNamePrefix ${DIR_ALIGN}/${CrossApat}_${FILE} \
	--outSAMattributes NH HI AS nM NM
echo ${FILE} reads aligned to ${CrossApat}

# Aligns F2 reads to F1 queen
STAR \
	--outSAMtype BAM SortedByCoordinate \
	--runThreadN ${THREADS} \
	--sjdbGTFfile ${DIR_INDEX}/${REF}.gtf \
	--genomeDir ${DIR_PARENT_GENOMES}/${CrossAmat} \
	--readFilesIn ${DIR_TRIM}/${FILE}_1.fastq ${DIR_TRIM}/${FILE}_2.fastq \
	--outFileNamePrefix ${DIR_ALIGN}/${CrossAmat}_${FILE} \
	--outSAMattributes NH HI AS nM NM
echo ${FILE} reads aligned to ${CrossAmat}
