#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_INDEX=~/scratch/AST/INDEX
DIR_PARENT_GENOMES=~/scratch/AST/PARENT_GENOMES

FILES=(G50_D G50_Q Y37_D Y37_Q)
#FILES=(B5_D B5_Q B96_D B96_Q)

# ----------------------------------------------

for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/8d_construct_F1_genomes_chil.sh ${FILE} ${DIR_INDEX} ${DIR_PARENT_GENOMES}
done
