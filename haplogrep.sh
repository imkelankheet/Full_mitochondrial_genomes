#!/bin/bash -l


#SBATCH -J HaploGrep
#SBATCH -A <snic_project_number>
#SBATCH -n 1
#SBATCH -p core
#SBATCH -t 01:00:00


# Run Haplogrep3
/home/<uppmax_username>/haplogrep3 classify --in MT_file.fasta --out HaploGrep3_MT_file.txt --tree phylotree-rcrs@17.2
