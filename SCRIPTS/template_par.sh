#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=0:10:00
#SBATCH --mem-per-cpu=1gb
#SBATCH --partition=open

SCRIPTS=~/work/AST/SCRIPTS
DIR_VARIANTS_FILTERED=~/work/AST/VARIANTS/FILTERED
DIR_INDEX=~/work/AST/INDEX
DIR_PARENT_GENOMES=~/work/AST/PARENT_GENOMES

#creats an array of IDs (for Sean's parental WGS files) to retrieve from sra
FILES=(SRR28865844 SRR28865843 SRR28865842 SRR28865841)

for FILE in ${FILES[@]}
do
	sbatch ${SCRIPTS}/template_chil.sh ${FILE} ${DIR_INDEX} ${DIR_PARENT_GENOMES} ${DIR_VARIANTS_FILTERED}
done
