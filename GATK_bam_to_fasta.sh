#!/bin/bash -l


#SBATCH -J MT_GATK
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p node
#SBATCH -o slurm_haplotypecaller_params
#SBATCH -t 1-00:00:00

module load bioinfo-tools
module load FastQC/0.11.8
module load bwa/0.7.17
module load samtools/1.10
module load GATK/4.1.4.1
module load bcftools

# The while loop loops over all the individuals and creates a fasta file containing the mt sequence for all individuals
while read -r samplename fw rv seqsample
do

# Working on this bam file
echo "Working on individual $seqsample ($samplename)"

# Creates a vcf file (variants, NOT all sites) for each individual
# the reference should have a .fasta.fai file and a .dict file
# setting max-reads-per-alignment-start to zero will avoid downsampling of you reads to 50
gatk --java-options -Xmx6g HaplotypeCaller \
-R pt_065_mito.fasta \
-I ${seqsample}/${seqsample}.mapped.bam \
--sample-ploidy 1 \
--max-reads-per-alignment-start 0 \
-O ${samplename}_haploid.vcf

# incorporating the variants in the vcf file (created in the previous step) into the reference
bgzip ${samplename}_haploid.vcf
tabix ${samplename}_haploid.vcf.gz
cat pt_065_mito.fasta | bcftools consensus ${samplename}_haploid.vcf.gz > ${samplename}.fa
sed "s/pt_065_mito/${samplename}/g" ${samplename}.fa > ${samplename}.fasta

done < pt_065_samplenames_UGC-ID.txt

# Make one fasta file for all Hessequa individuals, and one for all the DRC samples.
cat *.fasta > All_samples.fasta
