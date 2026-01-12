#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
DIR_INDEX=$1


wget -O ${DIR_INDEX}/Amel_HAv3.1.fasta.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/254/395/GCF_003254395.2_Amel_HAv3.1/GCF_003254395.2_Amel_HAv3.1_genomic.fna.gz

gunzip ${DIR_INDEX}/Amel_HAv3.1.fasta.gz

wget -O ${DIR_INDEX}/Amel_HAv3.1.gff.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/254/395/GCF_003254395.2_Amel_HAv3.1/GCF_003254395.2_Amel_HAv3.1_genomic.gff.gz

gunzip ${DIR_INDEX}/Amel_HAv3.1.gff.gz

wget -O ${DIR_INDEX}/Amel_HAv3.1.gtf.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/254/395/GCF_003254395.2_Amel_HAv3.1/GCF_003254395.2_Amel_HAv3.1_genomic.gtf.gz

gunzip ${DIR_INDEX}/Amel_HAv3.1.gtf.gz
