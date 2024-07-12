#!/bin/bash -e

  # Define script variables
  scriptDir=$(pwd)/$(dirname $0)
  execFile=${scriptDir}/src/lysozyme_in_water_full.py
  appPythonpath=${scriptDir}/src/

  # Retrieve arguments
  numNodes=$1
  executionTime=$2
  tracing=$3

  # Leave application args on $@
  shift 3

  # Load necessary modules
  module purge
  module load intel/2023.2.0 impi/2021.10.0 mkl/2023.2.0 bsc/1.0
  export COMPSS_PYTHON_VERSION=3.12.1
  module load COMPSs/3.3.1
  # Using gmx binary
  export GMX_BIN=/apps/GPP/COMPSs/TUTORIALS/Libraries/gromacs5.1.2/bin  # exposes gmx binary
  export PATH=${GMX_BIN}:$PATH
  # Using gmx_mpi binary
  module load gromacs/2023
  # module load intel/2018.4 mkl/2018.4 impi/2018.4 gromacs/2018.3  # exposes gmx_mpi binary
  # Using grace binary
  module load grace/5.1.25
  # module load gcc/13.2.0 

  # Submit the job
  enqueue_compss \
    --provenance=FULL.yaml \
    --summary \
    --project_name=bsc19 \
    --qos=gp_debug \
    --num_nodes=${numNodes} \
    --exec_time=${executionTime} \
    --worker_working_dir=${scriptDir} \
    --tracing=${tracing} \
    --graph=true \
    --log_level=off \
    --pythonpath=${appPythonpath} \
    --lang=python \
    $execFile $@


######################################################
# APPLICATION EXECUTION EXAMPLE
# Call:
#       ./launch_full.sh <NUMBER_OF_NODES> <EXECUTION_TIME> <TRACING> <CONFIG_PATH> <DATASET_PATH> <OUTPUT_PATH>
#
# Example:
#       ./launch_full.sh 2 10 true $(pwd)/config/ $(pwd)/dataset/ $(pwd)/output/
#
#####################################################
