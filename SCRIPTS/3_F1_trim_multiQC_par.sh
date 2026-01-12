#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
THREADS=4
DIR_REPORTS=~/scratch/AST/REPORTS/WGS
DIR_RAW=~/scratch/AST/RAW/WGS
DIR_TRIM=~/scratch/AST/TRIM/WGS

#creats an array of IDs F1 parents
#FILES=(G50_D G50_Q Y37_D Y37_Q)
FILES=(B5_D B5_Q B96_D B96_Q)

for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/3_F1_trim_multiQC_chil.sh ${FILE} ${THREADS} ${DIR_REPORTS} ${DIR_RAW} ${DIR_TRIM}
done
