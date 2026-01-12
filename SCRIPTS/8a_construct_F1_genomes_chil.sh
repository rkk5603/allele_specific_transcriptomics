#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
DIR_INDEX=$1


gatk CreateSequenceDictionary \
	-R ${DIR_INDEX}/Amel_HAv3.1.fasta \
	-O ${DIR_INDEX}/Amel_HAv3.1.dict

echo Sequence dictionary complete
