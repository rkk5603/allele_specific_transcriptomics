# Differential gene expression analysis
Here, a differential gene expression analysis is performed for "good" and "bad" honey bee nursing behavior. This Makefile is used to:
- Perform a bowtie alignment with 24 RNA seq samples
- Construct a gene expression matrix from resulting BAM files
- Construct a PCA plot and gene expression heat map
- Identify significant DEGs and their function

## Alignment
Two bash scripts are included for the bowtie alignment. The align_chil.sh script calls the "align" target in the Makefile. The align_par.sh script submits jobs to Penn State Roar, calling the align_chil.sh script for each of 24 RNA seq samples. First, a design.csv needs to be written for the samples, including at least two columns, "sample" and "group".
```
sample,group
G50_14,good
G50_22,good
G50_62,good
G50_12,bad
G50_25,bad
G50_60,bad
```

Before the alignment, a reference genome needs to be retrieved. Here, I retrieve the Apis mellifera ref genome in fasta, gff, and gtf format.
```
bash ref_genome_par.sh
```
The genome needs to be indexed before the alignment.
```
make index
```
Align_par.sh can be called. These 24 jobs will run fairly quickly on ROAR as opposed to using local resources.
```
bash align_par.sh
```
## Creating a count matrix 
### From the resulting BAM files, a matrix is produced that summarizes read counts for each dataset.
First, featureCounts will count the number of reads that overlap with each feature. This is performed as a parent job through ROAR again.
```
bash featurecounts_par.sh
```
With the counts.txt file, the matrix target performs three functions:
- counts_csv: converts counts.txt to .csv
- tx2gene: obtains informative gene names for the specified model (MAPPING)
- inform_geneIDs: adds the informative gene names to counts.csv

```
make matrix MAPPING=dmelanogaster_gene_ensembl
```
## Generate PCA and heatmap
The pca target in the Makefile calls two R scripts in the src toolkit.
- The edger.r script will process the counts.csv file to produce a differentially expressed genes matrix
- The plot_pca.r script will constuct a PC plot using the generated edger.csv file and design.csv.
```
make pca
```
edger.r output: 
```
Initializing edgeR tibble dplyr tools ... done
# Tool: edgeR
# Design: design.csv
# Counts: counts.csv
# Sample column: sample
# Factor column: group
# Factors: good bad
# Group good has 12 samples.
# Group bad has 12 samples.
# Method: glm
# Input: 12356 rows
# Removed: 2385 rows
# Fitted: 9971 rows
# Significant PVal:  258 ( 2.60 %)
# Significant FDRs:    0 ( 0.00 %)
# Results: edger.csv
```
PCA:
<img width="829" height="754" alt="image" src="https://github.com/user-attachments/assets/7afc8592-8526-4d0d-8bed-e7ab34c8b507" />

The heatmap target calls the plot_heatmap.r script to generate a heatmap for the differential expressed genes from the edger.csv file.
```
make heatmap
```
### Functional enrichment of differentially expressed genes
The enrichment target in the Makefile calls bio gprofiler to generate a gene homology csv using the edger.csv file.
```
make enrichment ORGANISM=hsapiens
```
