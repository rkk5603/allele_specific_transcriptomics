#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_INDEX=~/scratch/AST/INDEX
DIR_VARIANTS_FILTERED=~/scratch/AST/VARIANTS/FILTERED
DIR_ANALYSIS=~/scratch/AST/ANALYSIS_SETS
REF=Amel_HAv3.1

# first block
#CrossApat="G50_D"
#CrossAmat="G50_Q"
#CrossBpat="Y37_D"
#CrossBmat="Y37_Q"
#BLOCK=Block1

# second block
CrossApat="B5_D"
CrossAmat="B5_Q"
CrossBpat="B96_D"
CrossBmat="B96_Q"
BLOCK=Block2

sbatch ${SCRIPTS}/10_annotate_F1_SNPs_chil.sh ${DIR_INDEX} ${DIR_VARIANTS_FILTERED} ${DIR_ANALYSIS} ${REF} ${CrossApat} ${CrossAmat} ${CrossBpat} ${CrossBmat} ${BLOCK}
