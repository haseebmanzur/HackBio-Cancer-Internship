#!/bin/bash


#-------------------- Project 1 Commands ---------------------

# Step 1: Create a folder with your name and a biocomputing folder, then navigate to the biocomputing folder
mkdir -p Seebi && mkdir -p biocomputing && cd biocomputing

# Step 2: Download the necessary files from the provided URLs
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna \
	https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk \
	https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk

# Step 3: Move the .fna file to the folder with your name
mv wildtype.fna ../Seebi/

# Step 4: Remove the duplicate gbk file
rm wildtype.gbk.1

# Step 5: Check if the file is mutant by looking for "tatatata"
grep "tatatata" wildtype.fna

# Step 6: If mutant, save the mutant sequences in a new file
grep "tatatata" wildtype.fna > mutant_sequences.fna

# Step 7: Download your favorite gene in FASTA format from NCBI
wget "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?db=nuccore&id=NC_000006.12&report=fasta&retmode=text" -O NC_000006.12.fasta

# Step 8: Count the number of lines in the FASTA file excluding the header
grep -v "^>" NC_000006.12.fasta | wc -l

# Step 9: Count occurrences of A, G, C, and T
grep -v "^>" NC_000006.12.fasta | grep -o "A" | wc -l
grep -v "^>" NC_000006.12.fasta | grep -o "G" | wc -l
grep -v "^>" NC_000006.12.fasta | grep -o "C" | wc -l
grep -v "^>" NC_000006.12.fasta | grep -o "T" | wc -l

# Step 10: Calculate the %GC content of the gene
grep -v "^>" NC_000006.12.fasta | tr -d '\n' | awk '{gc=gsub(/[GC]/,""); total=length($0); print (gc/total)*100}'

# Step 11: Create a FASTA file with your name and a nucleotide sequence
echo -e ">Seebi\nATGCGTACGTAGCTAGCTAGCTAGCTAGCTAGCTAGCGATCGTAGCT" > ../Seebi/Seebi.fasta

# Step 12: Append the counts of A, G, T, and C to the file
echo -e "A: $(grep -o 'A' ../Seebi/Seebi.fasta | wc -l)\nG: $(grep -o 'G' ../Seebi/Seebi.fasta | wc -l)\nT: $(grep -o 'T' ../Seebi/Seebi.fasta | wc -l)\nC: $(grep -o 'C' ../Seebi/Seebi.fasta | wc -l)" >> ../Seebi/Seebi.fasta

# Step 13: Upload the Seebi.fasta file to the team's GitHub repository in the /output folder
git clone https://github.com/haseebmanzur/hackbio-cancer-internship && cd hackbio-cancer-internship/Task3/Stage1/Output/ \
	&& mv ../../../../Seebi/Seebi.fasta . && git add Seebi.fasta && git commit -m "Add Seebi.fasta file to output folder" && git push origin main

# --------------------- Project 2 Commands ---------------------

# Step 1: Activate your base conda environment
conda activate base

# Step 2: Create a conda environment called funtools
conda create --name funtools

# Step 3: Activate the funtools environment
conda activate funtools

# Step 4: Install Figlet using conda
conda install -c conda-forge figlet

# Step 5: Run Figlet with your name
figlet Seebi

# Step 6: Install bwa through the bioconda channel
conda install -c bioconda bwa

# Step 7: Install blast through the bioconda channel
conda install -c bioconda blast

# Step 8: Install samtools through the bioconda channel
conda install -c bioconda samtools

# Step 9: Install bedtools through the bioconda channel
conda install -c bioconda bedtools

# Step 10: Install spades.py through the bioconda channel
conda install -c bioconda spades

# Step 11: Install bcftools through the bioconda channel
conda install -c bioconda bcftools

# Step 12: Install fastp through the bioconda channel
conda install -c bioconda fastp

# Step 13: Install multiqc through the bioconda channel
conda install -c bioconda multiqc

