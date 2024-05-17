#!/bin/bash -l


#SBATCH -J MAFFT_mtDNA_alignment
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p node
#SBATCH -t 02:00:00

# Load required modules
module load bioinfo-tools
module load MAFFT/7.407

# Align with mafft
mafft --thread 20 file.fasta > file_aligned.fasta
