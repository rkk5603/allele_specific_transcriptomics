#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR=~/scratch/AST/RAW/mRNA

#creats an array of IDs (for Sean's parental WGS files) to retrieve from sra
#FILES=(G50_D G50_Q Y37_D Y37_Q B5_D B5_Q B96_D B96_Q)
FILES=(A B C D E F G H I J K L M N O P Q R S T U V W X)
for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/unzip_chil.sh ${FILE} ${DIR}
done
