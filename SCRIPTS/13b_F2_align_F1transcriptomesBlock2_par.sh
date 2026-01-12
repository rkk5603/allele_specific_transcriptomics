#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_TRIM=~/scratch/AST/TRIM/mRNA
DIR_PARENT_GENOMES=~/scratch/AST/PARENT_GENOMES
DIR_ALIGN=~/scratch/AST/ALIGN_PARENT_GENOMES/UNFILTERED
DIR_INDEX=~/scratch/AST/INDEX
THREADS=12
REF=Amel_HAv3.1

# block 1
#CrossBpat="Y37_D"
#CrossBmat="Y37_Q"
#CrossB=(J K L I G)

# block 2
CrossBpat="B96_D"
CrossBmat="B96_Q"
CrossB=(V W X S T U)

for FILE in ${CrossB[@]}
do
	sbatch ${SCRIPTS}/13b_F2_align_F1transcriptomes_chil.sh ${FILE} ${DIR_TRIM} ${DIR_PARENT_GENOMES} ${DIR_ALIGN} ${DIR_INDEX} ${THREADS} ${CrossBpat} ${CrossBmat} ${REF}
done
