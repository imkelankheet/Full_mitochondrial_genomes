#!/bin/bash -l


#SBATCH -J MT_coverage_determination
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p node
#SBATCH -t 1:00:00

# Load required modules
module load bioinfo-tools
module load samtools

# The for loop loops over all the individuals and calculates the coverage for that individual, writes it to a file
while read -r samplename fw rv seqsample
do
samtools depth ${seqsample}/${seqsample}.mapped.bam | awk -v samplename="$samplename" '{sum+=$3} END { print samplename, sum/NR}'
done < samples_barcodes_pt221.txt > coverage.txt
