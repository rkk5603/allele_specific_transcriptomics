#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_INDEX=~/scratch/AST/INDEX

sbatch ${SCRIPTS}/8a_construct_F1_genomes_chil.sh ${DIR_INDEX}
