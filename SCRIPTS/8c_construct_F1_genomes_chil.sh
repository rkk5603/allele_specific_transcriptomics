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

# Reformats the headers of F1 .fasta files produced by gatk to match accessions in reference fasta

# Get all sequence headers from one of the F1 genomes (= "bad"")
grep ">" ${DIR_PARENT_GENOMES}/${FILE}.fasta \
| sed 's/>//g' > ${DIR_INDEX}/bad_headers.txt

# Get all sequence headers from the reference genome (= "good"")
grep ">" ${DIR_INDEX}/Amel_HAv3.1.fasta \
| sed 's/\s.*$//' | sed 's/>//g' > ${DIR_INDEX}/good_headers.txt

# Combine the "bad" and "good" headers into one .tsv
paste -d"\t" ${DIR_INDEX}/bad_headers.txt ${DIR_INDEX}/good_headers.txt \
> ${DIR_INDEX}/replace_headers.tsv

