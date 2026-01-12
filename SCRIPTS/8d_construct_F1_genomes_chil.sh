#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
DIR_INDEX=$2
DIR_PARENT_GENOMES=$3

# Use replace_headers.tsv as a lookup table for replacement
awk 'FNR==NR{a[">"$1]=$2;next}$1 in a{sub(/>/,">"a[$1]"|",$1)}1' \
	${DIR_INDEX}/replace_headers.tsv ${DIR_PARENT_GENOMES}/${FILE}.fasta \
	| sed 's/:.*//' > ${DIR_PARENT_GENOMES}/${FILE}_fixed.fasta

echo ${FILE} headers replaced
