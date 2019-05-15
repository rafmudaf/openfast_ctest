#!/bin/bash -l
#PBS -A hfm
#PBS -N openfast_regression_gnu
#PBS -q short
#PBS -o $PBS_JOBNAME.log
#PBS -j oe
#PBS -l nodes=1:ppn=24
#PBS -l walltime=4:00:00
#PBS -l feature=haswell

# this ensures your job runs from the directory from which you run the qsub command
#cd $PBS_O_WORKDIR
cd /home/rmudafor/cdash

gnumodules

./ctest.sh continuous gfortran $FC $BLASLIB
