#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_REPORTS=~/scratch/AST/REPORTS/mRNA

sbatch ${SCRIPTS}/12c_F2_multiqc_chil.sh ${DIR_REPORTS}
