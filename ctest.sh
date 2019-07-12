#!/bin/bash -l
#SBATCH --ntasks=24
#SBATCH --nodes=1
#SBATCH --time=4:00:00
#SBATCH --account=hfm
#SBATCH --job-name=openfast-regression
#SBATCH --output=openfast_regression_%j.log

usage="Usage: $0 <build_type [nightly-continuous-experimental]> <compiler [ifort-gfortran]> <compiler_path>"

cd /home/rmudafor/Development/cdash

timestamp=`date +%b%d_%I%M%P`
logfile=test_logs/$1_$2_$timestamp

echo "***** Start $0" > $logfile
echo "" >> $logfile

if [[ "$#" -lt 2 ]]
then
  echo $usage
  exit 1
fi

if [[ $1 != "continuous" ]] && [[ $1 != "nightly" ]] && [[ $1 != "experimental" ]]
then
  echo $usage
  exit 2
fi

if [[ $2 != "ifort" ]] && [[ $2 != "gfortran" ]]
then
  echo $usage
  exit 3
fi

# TODO: check that compilerpath $3 exists
# if [[ ! -e $3 ]] ??
# then
#   echo $usage
#   exit 4
# fi

ctest -VV -S /home/rmudafor/Development/cdash/CTestSteer.cmake -DMODEL=$1 -DCOMPILERFLAG=$2 -DCOMPILERPATH=$3 >> test_logs/$1_$2_$timestamp

echo "" >> $logfile
echo "***** End $0" >> $logfile
