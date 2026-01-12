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

fastqc \
	-t ${THREADS} \
	${DIR_RAW}/${FILE}_1.fastq ${DIR_RAW}/${FILE}_2.fastq \
	--outdir ${DIR_REPORTS}

