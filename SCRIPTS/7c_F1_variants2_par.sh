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

#FILES=(G50_D G50_Q Y37_D Y37_Q)
FILES=(B5_D B5_Q B96_D B96_Q)

# --------------------------------------------------

for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/7c_F1_variants_chil.sh ${FILE} ${DIR_VARIANTS_FILTERED} ${DIR_VARIANTS} ${QUAL} ${MINDP} ${MAXDP}
done

echo finished
