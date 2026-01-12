#!/bin/bash


REF=Amel_HAv3.1
DIR_INDEX=~/scratch/AST/INDEX

# ------------------------

# index ref genome 
bwa index ${DIR_INDEX}/${REF}.fasta
