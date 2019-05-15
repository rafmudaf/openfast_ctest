#!/bin/bash -l
#SBATCH --ntasks=24
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --account=hfm
#SBATCH --job-name=openfast-regression-intel
#SBATCH --output=openfast_regression_intel_%j.log

cd /home/rmudafor/Development/cdash

# load the appropriate modules
source intel_modules.sh

#srun bash ctest.sh nightly ifort $FC "$blaslib"
#bash ctest.sh nightly ifort $FC
