#!/bin/bash -l
#SBATCH --ntasks=24
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --account=hfm
#SBATCH --job-name=openfast-regression-intel
#SBATCH --output=openfast_regression_intel_%j.log

cd /home/rmudafor/Development/cdash

# load the appropriate modules
module purge
module load cmake/3.12.3
module load comp-intel/2018.0.3
module load mkl/2018.3.222

source ctest.sh continuous intel $FC
