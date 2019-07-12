#!/bin/bash -l
#SBATCH --ntasks=24
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --account=hfm
#SBATCH --job-name=openfast-regression-gnu
#SBATCH --output=openfast_regression_gnu_%j.log

cd /home/rmudafor/Development/cdash

# load the appropriate modules
module purge
module load cmake/3.12.3
module load gcc/7.3.0
export FC=/nopt/nrel/apps/compilers/spack/opt/spack/linux-centos7-x86_64/gcc-4.8.5/gcc-7.3.0-vydnujncq3lpwhhnxmauinsqxkhxy4gn/bin/gfortran

source ctest.sh continuous gfortran $FC
