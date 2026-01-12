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
DIR_ALIGN_FILTERED=$4
DIR_REPORTS=$5

# 1. name-sort
samtools sort -n -o ${DIR_ALIGN_FILTERED}/${FILE}_name_srtd.bam ${DIR_ALIGN}/${FILE}.bam
echo Name sorting completed, step 1 of 4

# 2. Add mate information
samtools fixmate -m ${DIR_ALIGN_FILTERED}/${FILE}_name_srtd.bam ${DIR_ALIGN_FILTERED}/${FILE}_fixmate.bam
echo Fixmate completed, step 2 of 4

# 3. Coordinate-sort
samtools sort -o ${DIR_ALIGN_FILTERED}/${FILE}_coord_srtd.bam ${DIR_ALIGN_FILTERED}/${FILE}_fixmate.bam
echo Coordinate sorting completed, step 3 of 4

# 4. Remove duplicates
samtools markdup -r ${DIR_ALIGN_FILTERED}/${FILE}_coord_srtd.bam ${DIR_ALIGN_FILTERED}/${FILE}_dedup.bam
echo Duplicates removed, step 4 of 4

echo finished
