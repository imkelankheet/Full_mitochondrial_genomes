#!/bin/bash -l


#SBATCH -J MT_DV_filtering+fasta
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p node
#SBATCH -o slurm_DP_filtering+fasta
#SBATCH -t 1-00:00:00

# Load required modules
module load bioinfo-tools
module load FastQC/0.11.8
module load bwa/0.7.17
module load samtools/1.10
module load GATK/4.1.4.1
module load bcftools
module load vcflib

deepvariant_directory="/deepvariant_directory"
reference_directory="/reference_directorys"
filtered="/filtered_directory"
filteredfasta="/filteredfasta_directory"

# The while loop loops over all the individuals and creates a new vcf file, which is filtered for 1/1 sites in the deepvariant analysis (this filters out heteroplasmy).
# In this loop, a fasta file is also created from this new vcf file.
while read -r samplename fw rv seqsample
do

# Working on this vcf file
echo "Working on individual $seqsample ($samplename)"
echo "${deepvariant_directory}/${seqsample}.vcf.gz"

# Keeping only the 1/1 sites. This filters out heteroplasmy.
cd ${deepvariant_directory}/
vcffilter -g " (GT = 1/1 )"  ${seqsample}.vcf.gz > ${filtered}/${seqsample}_filtered_no_heteroplasmy.vcf
bgzip -f ${filtered}/${seqsample}_filtered_no_heteroplasmy.vcf
tabix ${filtered}/${seqsample}_filtered_no_heteroplasmy.vcf.gz

# Create fasta file
cat ${reference_directory}/doubleHumanMito.fasta | bcftools consensus -s $samplename ${filtered}/${seqsample}_filtered_no_heteroplasmy.vcf.gz > ${filteredfasta}/${samplename}_no_heteroplasmy.fa
sed "s/doubleHumanMito/${samplename}/g" ${filteredfasta}/${samplename}_no_heteroplasmy.fa > ${filteredfasta}/${samplename}_deepvariant_no_heteroplasmy_min_s_option.fasta
rm -f ${filteredfasta}/${samplename}_no_heteroplasmy.fa

done < samples_barcodes_pt221.txt

# Combine all into one fasta file
cd ${filteredfasta}
cat *.fasta > All_samples_no_rCRS_min_s_option_unaligned.fasta
