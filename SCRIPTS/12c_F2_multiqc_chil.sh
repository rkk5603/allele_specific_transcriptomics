#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
DIR_REPORTS=$1

multiqc ${DIR_REPORTS}/. \
	-o ${DIR_REPORTS} \
	-n mRNA.html

echo multiqc report generated
