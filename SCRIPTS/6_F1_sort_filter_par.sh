#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
THREADS=6
DIR_ALIGN=~/scratch/AST/ALIGN_GENOME/UNFILTERED
DIR_ALIGN_FILTERED=~/scratch/AST/ALIGN_GENOME/FILTERED
DIR_REPORTS=~/scratch/AST/REPORTS/WGS

#FILES=(G50_D G50_Q Y37_D Y37_Q)
FILES=(B5_D B5_Q B96_D B96_Q)

# -----------------------------------------------------
for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/6_F1_sort_filter_chil.sh ${FILE} ${THREADS} ${DIR_ALIGN} ${DIR_ALIGN_FILTERED} ${DIR_REPORTS}
done

