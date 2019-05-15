#!/usr/bash -l

module purge

module load cmake/3.12.3
module load conda/5.3
source activate openfast
module load gcc/7.3.0

export FC=/nopt/nrel/apps/compilers/spack/opt/spack/linux-centos7-x86_64/gcc-4.8.5/gcc-7.3.0-vydnujncq3lpwhhnxmauinsqxkhxy4gn/bin/gfortran
