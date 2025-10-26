## Target descriptions
### Amel_ref
Retrieves apis mellifera reference genome
### 1_prefetchWGS
Retrieves WGS reads from SRA
### 2_rawQC
Runs fastqc for each WGS library
### 3_trim_multiQC
Runs fastp on WGSto remove low quality reads and trim adapter sequences
### 4_indexRef
### 5_align
### 6_sort_filter
### 7_find_variants
### 8_construct_F1_genomes
### 9_construct_F1_transctiptomes
### 10 get gene annotations
Subset the Amel_HAv3.1 reference genome feature file (gff) to gene features, and modify column 9 (the info column) to keep only the RefSeq GeneID (these will be used in all downstream analyses).

### 11_ID_F1_SNPs
Identifies the informative SNPs by taking the difference of each respective parental SNP call set (i.e., SNPs unique to each parent) and finding the intersection between crosses

