#!/usr/bin/env bash

# pipeline configuration is done by input
if [ $# -ne 2 ]
  then
    echo "Usage: $0 <input_data_folder> <pipeline_output>"
    exit 1
fi

input_data_folder=$1
pipeline_output=$2
profile="lsf"

# setup
mkdir -p "$pipeline_output"

# installation
echo "Running installation pipeline..."
cd installation_pipeline
source venv/bin/activate
snakemake --restart-times 0 --profile "$profile" --config input_data_folder="$input_data_folder" \
  pipeline_output="$pipeline_output" || { echo 'FATAL ERROR: installation pipeline failed;' ; exit 1; }
deactivate
cd ../


# run each pipeline one by one
echo "Running pangenome_variations pipeline..."
cd ${pipeline_output}/pangenome_variations
source venv/bin/activate
snakemake --profile "$profile" --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  || { echo 'FATAL ERROR: pangenome_variations pipeline failed;' ; exit 1; }
deactivate
cd ../../


echo "Running subsampler pipeline..."
cd ${pipeline_output}/subsampler
source venv/bin/activate
snakemake --profile "$profile" --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  || { echo 'FATAL ERROR: subsampler pipeline failed;' ; exit 1; }
deactivate
cd ../../


echo "Running pandora_analysis_pipeline..."
cd ${pipeline_output}/pandora_analysis_pipeline
source venv/bin/activate
bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  || { echo 'FATAL ERROR: pandora_analysis_pipeline failed;' ; exit 1; }
deactivate
cd ../../


echo "Running variant_callers_pipeline..."
cd ${pipeline_output}/variant_callers_pipeline
source venv/bin/activate
snakemake --profile "$profile" --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  --keep-going --stats variant_callers_pipeline_runtime_stats || { echo 'FATAL ERROR: variant_callers_pipeline failed;' ; exit 1; }
deactivate
cd ../../


echo "Running pandora1_paper pipeline..."
cd ${pipeline_output}/pandora1_paper
source venv/bin/activate
bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  --keep-going || { echo 'FATAL ERROR: pandora1_paper pipeline failed;' ; exit 1; }
deactivate
cd ../../
