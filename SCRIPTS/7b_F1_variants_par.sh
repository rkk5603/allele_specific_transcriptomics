#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_VARIANTS=~/scratch/AST/VARIANTS/UNFILTERED
DIR_VARIANTS_FILTERED=~/scratch/AST/VARIANTS/FILTERED
DIR_ALIGN_FILTERED=~/scratch/AST/ALIGN_GENOME/FILTERED
DIR_REPORTS=~/scratch/AST/REPORTS/WGS
DIR_INDEX=~/scratch/AST/INDEX
QUAL=30
MINDP=10
MAXDP=50

# Haploid parents
HAPLOID=(G50_D Y37_D)
#HAPLOID=(B5_D B96_D)

# ---------------------------------------------
for FILE in ${HAPLOID[@]}
do
	sbatch ${SCRIPTS}/7b_F1_variants_chil.sh ${FILE} ${DIR_ALIGN_FILTERED} ${DIR_INDEX} ${DIR_VARIANTS}
done
