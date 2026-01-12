#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_OUT=~/scratch/AST/RAW/WGS

#creats an array of IDs (for Sean's parental WGS files) to retrieve from sra
FILES=(SRR28865844 SRR28865843 SRR28865842 SRR28865841)
for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/1_prefetchWGS_chil.sh ${FILE} ${DIR_OUT}
done
