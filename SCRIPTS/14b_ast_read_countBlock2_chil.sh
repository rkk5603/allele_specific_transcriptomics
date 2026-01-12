#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=open

# Assign arguments from sbatch command called in parent script to variables
FILE=$1
ASET=$2
DIR_ANALYSIS=$3
DIR_INDEX=$4
DIR_ALIGN=$5
DIR_ALIGN_FILTERED=$6
DIR_COUNT=$7
THREADS=$8
REF=$9

# Cross B parents
#Parents=("Y37_D" "Y37_Q")
Parents=("B96_D" "B96_Q")

for PARENT in "${Parents[@]}"
do
	# Keep only mapped, primary alignments with 0 mismatches
	samtools view -@ ${THREADS} -m 6G -e '[NM]==0' -F 260 -O BAM \
		${DIR_ALIGN}/${PARENT}_${FILE}Aligned.sortedByCoord.out.bam \
		> ${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}_sorted.bam
	echo Generated ${FILE}_sorted.bam step 1 of 5

	# Index the alignments
	samtools index ${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}_sorted.bam \
		${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}_sorted.bam.bai
	echo Indexed ${FILE}_sorted.bam step 2 of 5

	# Convert BAM to BED
	bedtools bamtobed -i ${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}_sorted.bam \
		> ${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}.bed
	echo ${FILE}_sorted.bam converted to .bed step 3 of 5

	# Sort BED by coordinate
	sort --parallel=${THREADS} \
		-k1,1 -k2,2n ${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}.bed \
		> ${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}_sorted.bed
	echo ${FILE}_sorted.bed sorted by coordinate step 4 of 5

	# Count reads by SNP accounting for strand of alignment
	bedtools intersect -S -sorted -c -a ${ASET} \
		-b ${DIR_ALIGN_FILTERED}/${PARENT}_${FILE}_sorted.bed \
		> ${DIR_COUNT}/${PARENT}_${FILE}.txt
	echo ${FILE} counts generated step 5 of 5

done

echo finished
