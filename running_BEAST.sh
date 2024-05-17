#!/bin/bash -l


#SBATCH -J Beast
#SBATCH -A <snic_project_number>
#SBATCH -n 3
#SBATCH -p core
#SBATCH -t 10-00:00:00

# Load required modules
module load bioinfo-tools
module load beast/1.8.4

# Change this according to the amount of cores you are running it on. Maximum 6.4 GB of RAM per core.
export BEAST_XMX=18g

# Creating directory where beast will be run, the first argument is the iteration number. 
directory="/directory_with_xml_file"
mkdir ${directory}/${1}.Run/
cd ${directory}/${1}.Run/

# Running beast (file.xml is created in BEAUTI)
beast -beagle_gpu -beagle_order 1 ${directory}/file.xml

