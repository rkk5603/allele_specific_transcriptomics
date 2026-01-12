#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
THREADS=4
DIR_ALIGN=~/scratch/AST/ALIGN_GENOME/UNFILTERED
DIR_INDEX=~/scratch/AST/INDEX
DIR_TRIM=~/scratch/AST/TRIM/WGS

#FILES=(G50_D G50_Q Y37_D Y37_Q)
FILES=(B5_D B5_Q B96_D B96_Q)

# -----------------------

for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/5_F1_align_chil.sh ${FILE} ${THREADS} ${DIR_ALIGN} ${DIR_INDEX} ${DIR_TRIM}
done
