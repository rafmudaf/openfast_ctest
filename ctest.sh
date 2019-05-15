#!/bin/bash -l

#SBATCH --ntasks=24
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --account=hfm
#SBATCH --job-name=openfast-regression
#SBATCH --output=openfast_regression_%j.log

usage="Usage: $0 build_type[nightly | continuous | experimental] compiler[ifort | gfortran]"

if [[ "$#" -lt 2 ]]
then
  echo $usage
  exit 1
fi

if [[ $1 != "continuous" ]] && [[ $1 != "nightly" ]] && [[ $1 != "experimental" ]]
then
  echo $usage
  exit 1
fi

if [[ $2 != "ifort" ]] && [[ $2 != "gfortran" ]]
then
  echo $usage
  exit 2
fi

cd /home/rmudafor/Development/cdash

# load the appropriate modules
if [[ $2 == "ifort" ]]
then
  source intel_modules.sh
fi
if [[ $2 == "gfortran" ]]
then
  source gnu_modules.sh
fi

timestamp=`date +%b%d_%I%M%P`
ctest -VV -S /Users/rmudafor/Development/cdash/CTestSteer.cmake -DMODEL=$1 -DCOMPILERFLAG=$2 -DCOMPILERPATH=$3 -DBLASLIB="$4" #/home/rmudafor/Development/cdash/CTestSteer.cmake -DMODEL=$1 -DCOMPILERFLAG=$2 -DCOMPILERPATH=$3 -DBLASLIB="$4" > test_logs/$1_$2_$timestamp

