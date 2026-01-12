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

# Cross A

# block 1
#CrossApat="G50_D"
#CrossAmat="G50_Q"
#CrossA=(D E F H A B C)

# block 2
CrossApat="B5_D"
CrossAmat="B5_Q"
CrossA=(P Q R N O M)

for FILE in ${CrossA[@]}
do
	sbatch ${SCRIPTS}/13a_F2_align_F1transcriptomes_chil.sh ${FILE} ${DIR_TRIM} ${DIR_PARENT_GENOMES} ${DIR_ALIGN} ${DIR_INDEX} ${THREADS} ${CrossApat} ${CrossAmat} ${REF}
done
