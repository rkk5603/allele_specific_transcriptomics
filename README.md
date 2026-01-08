# **Sequence reads to SNP-level parent-specific read counts**
## 1. Generation of F1 genomes
### Amel_ref
Retrieves apis mellifera reference genome
### 1_prefetchWGS
Retrieves WGS reads from SRA
### 2_F1_rawQC
Runs fastqc for each WGS library
### 3_F1_trim_multiQC
Runs fastp (with default settings) on WGS to remove low quality reads and trim adapter sequences
### 4_indexRef
Indexes reference genome in preparation for alignment of WGS reads
### 5_F1_align
Aligns reads to the Amel_HAv3.1 reference genome assembly with BWA-MEM
### 6_F1_sort_filter
Alignments are sorted by coordinate and filtered to remove unmapped reads, reads with unmapped mates, secondary, supplementary, and duplicate alignments. Filtering is important for later variant calling steps to avoid false positive and negative calls.
### 7_F1_find_variants
Variants (SNPs, MNPs, & indels) are identified using freebayes to account for differences in ploidy between DIPLOID and HAPLOID samples. After variant discovery, the variant call files (VCFs) are then subset to homozygous SNPs and filtered by quality (QUAL), minimum depth of coverage (MINDP) and maximum depth of coverage (MAXDP) using samtools and VCFtools, compressed with bgzip and indexed with tabix (samtools).

### 8_construct_F1_genomes
Constructs F1 parent genomes. A “sequence dictionary” is generated from the Amel_HAv3.1 reference genome for use with GATK. Then, the high-quality homozygous SNPs are integrated into the Amel_HAv3.1 reference genome for each parent to generate individual genomes. The numeric headers of the F1 genome .fasta files produced by GATK are reformatted to match the nucleotide accessions in the headers of the Amel_HAv3.1 reference genome fasta file.
This will replace the sequential numeric sequence headers in the resultant F1 genome .fasta files produced by GATK, e.g.,
```
>1
ATCCTCCACCT....
>2 
GGGAATTGCCA....
```

With the nucleotide accessions in the sequence headers of the Amel_HAv3.1 reference genome fasta file, e.g.,
```
>NC_037638.1
ATCCTCCACCT....
>NC_037639.1
GGGAATTGCCA....
```
This step is critical for the final mRNA-seq allele-specific read counting step as the chromosome field of the annotation file used to assign counts to transcripts must match the chromosome field of the alignment files used for counting.

### 9_construct_F1_transctiptomes
This step assembles F1 transcriptomes using the gtf reference.

### 10_annotate_F1_SNPs
Here, the high-quality homozygous SNPs for each reciprocal cross are intersected to find those that are unique to each parent but shared between the crosses. This target does three things:
- First, the Amel_HAv3.1 reference genome feature file (gff) is subset to gene features, and column 9 (the info column) is used to keep only the RefSeq GeneID (these will be used in all downstream analyses).
- Then informative SNPs are identified by taking the difference of each respective parental SNP call set (i.e., SNPs unique to each parent) and finding the intersection between crosses.
- Finally, the script annotates the genes with the positions of informative F1 SNPs. These SNPs will be later subset to those within the longest transcript for each gene. Mitochondrial genes (on the chromosome with nucleotide accession “NC_001566.1”) are filtered, as these are innapropriate for assessing parent-of-origin effects (as all mitochondrial genes will be maternally expressed).

## 2. Quantification of F2 allele-specific transcription
### 11_F2_fetch_mRNA
RNA seq reads for F2 samples are retrieved from SRA.

### 12_F2rawQC
Performs fastp on F2 mRNA fastq files and multiQC to compare before/after low quality read and adapter trimming.

### 13_F2_align_F1transcriptome
The mRNA-seq reads for each F2 sample are aligned to their respective parental F1 transcriptomes.

### 14_ast_read_count
Post-processing of mRNA seq alignment and allele-specific read counting.

# 3. SNP-level parent-specific read counts to allele-specific transcription
## 3.2 R Setup
- Install packages. This only needs to be done once.
- Load packages
- Source custom functions
- Generate sample metadata table
  
### 3.3.1 Filter SNPs by transcript
- Load in filter list
- Make txdb from honey bee gene annotations
- Execute filter_SNPs function
- Write output to SNPS.csv

### 3.3.2 Merge count files to matrix
- Execute merge_AST_count_matrix function
- Order the columns of SNP_counts to be the same as metadata sample.id column
- Write to SNP_gene_counts.csv

## 3.4 PREPARE SAMPLE X SNP:GENE COUNTS FOR ANALYSIS 
### 3.4.1 normalize by library size
To adjust for differences in sequencing depth between libraries, library size factors are estimated and the read counts are normalized using the median of ratios normalization (MRN) method from DESeq2.
- Execute calcSizeFactors function
- Execute normalizeASReadCounts
- Write to SNP_gene_counts_normalized.csv

### 3.4.2 Split by phenotype and filter low count SNPs
- Execute filter_counts for both phenotypes
- Write to phenotype1_counts_normalized.csv and phenotype2_counts_normalized.csv

## 3.5 Conduct Statistical Tests
### 3.5.1 SNP-level Storer-Kim (SK) binomial exact tests
For each SNP, a Storer-Kim binomial exact test of two proportions is conducted using the MRN counts to test the hypothesis that the proportion of maternal and paternal read counts are statistically different 
- Execute AST.SK function for both phenotypes (a wrapper function for twobinom function)
- Write to phenotype_SK.csv

### 3.5.2 Gene-level general linear mixed models (GLIMMIX)
For each gene, GLIMMIX assess the effects of Parent, Lineage, and their interaction on the raw read counts at each SNP, using the log of the library size factors as an offset to adjust for variation in sequencing depth between libraries.
- Execute AST.GLIMMIX function for both phenotypes
- Write to phenotype_GLIMMIX.csv

## 3.6 Allele-specific transcription analysis
### 3.6.1 FDR correction and threshold tests
- Execute AST.Analysis for each phenotype_GLIMMIX.csv
- Write to phenotype_AST.csv

### 3.6.2 Chi-squared tests
- Execute AST.chisq once for both phenotype_AST.csv simultaneously

## 3.7 Data Visualization
### Reorder the data generated by AST.Analysis so that unbiased genes appear first
### Collapse the data generated by AST.Analysis and calculate p1 and p2 by gene
- Execute AST.collapse for each phenotype_counts_normalized
- Write to phenotype_AST_collapse.csv

### Generate the scatter plots
- Execute AST.scatter for both phenotype.collapse
- Execute chisq.table

