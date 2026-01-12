#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
THREADS=8
DIR_RAW=~/scratch/AST/RAW/mRNA
DIR_REPORTS=~/scratch/AST/REPORTS/mRNA
DIR_TRIM=~/scratch/AST/TRIM/mRNA

#creats an array of IDs (for Sean's parental WGS files) to retrieve from sra
FILES=(A B C D E F G H I J K L M N O P Q R S T U V W X)

for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/12b_F2_fastp_chil.sh ${FILE} ${THREADS} ${DIR_RAW} ${DIR_REPORTS} ${DIR_TRIM}
done
