#!/usr/bash -l

module purge

module load cmake/3.12.3
module load conda/5.3
source activate openfast
module load comp-intel/2018.0.3
module load mkl/2018.3.222

export FC=/nopt/nrel/apps/compilers/spack/opt/spack/linux-centos7-x86_64/gcc-4.8.5/intel-parallel-studio-cluster.2018.3-6wq2vvslzhamadvc66fecse5bgcdhjzt/compilers_and_libraries_2018.3.222/linux/bin/intel64/ifort
