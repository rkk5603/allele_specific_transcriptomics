#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_INDEX=~/scratch/AST/INDEX

#creats an array of IDs (for Sean's parental WGS files) to retrieve from sra
sbatch ${SCRIPTS}/ref_genome_chil.sh ${DIR_INDEX}
