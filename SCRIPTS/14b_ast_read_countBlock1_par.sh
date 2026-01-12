#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
REF=Amel_HAv3.1
DIR_ANALYSIS=~/scratch/AST/ANALYSIS_SETS
DIR_INDEX=~/scratch/AST/INDEX
DIR_ALIGN=~/scratch/AST/ALIGN_PARENT_GENOMES/UNFILTERED
DIR_ALIGN_FILTERED=~/scratch/AST/ALIGN_PARENT_GENOMES/FILTERED
DIR_COUNT=~/scratch/AST/COUNT
THREADS=10
BLOCK=Block1
#BLOCK=Block2
ASET="${DIR_ANALYSIS}/${BLOCK}_SNPs_for_Analysis_Sorted.bed"

CrossB=(J K L I G)
#CrossB=(V W X S T U)

for FILE in ${CrossB[@]}
do
	sbatch ${SCRIPTS}/14b_ast_read_countBlock1_chil.sh \
	${FILE} ${ASET} ${DIR_ANALYSIS} ${DIR_INDEX} ${DIR_ALIGN} ${DIR_ALIGN_FILTERED} ${DIR_COUNT} ${THREADS} ${REF}
done
