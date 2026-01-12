#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
THREADS=$2
DIR_REPORTS=$3
DIR_RAW=$4
DIR_TRIM=$5

fastp \
	-w ${THREADS} \
	-i ${DIR_RAW}/${FILE}_1.fastq -I ${DIR_RAW}/${FILE}_2.fastq \
	-o ${DIR_TRIM}/${FILE}_1.fastq -O ${DIR_TRIM}/${FILE}_2.fastq \
	-j ${DIR_REPORTS}/${FILE}_fastp.json

multiqc ${DIR_REPORTS}/. \
	-o ${DIR_REPORTS} \
	-n WGS.html
