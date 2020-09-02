#!/usr/bin/env bash

# pipeline configuration is done by input
if [ $# -ne 2 ]
  then
    echo "Usage: $0 <zipped_input_data> <pipeline_output>"
    exit 1
fi

zipped_input_data=$1
pipeline_output=$2
profile="lsf"

# setup
mkdir -p "$pipeline_output"

# installation
cd installation_pipeline
source venv/bin/activate
snakemake --snakefile Snakefile_setup --restart-times 0 --profile "$profile" --config zipped_input_data="$zipped_input_data" \
  pipeline_output="$pipeline_output" || { echo 'FATAL ERROR: installation pipeline failed;' ; exit 1; }
deactivate
cd ../


# run each pipeline one by one
cd ${pipeline_output}/pangenome_variations
source venv/bin/activate
snakemake --profile lsf --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  || { echo 'FATAL ERROR: pangenome_variations pipeline failed;' ; exit 1; }
deactivate
cd ../../

cd ${pipeline_output}/subsampler
source venv/bin/activate
snakemake --profile lsf --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  || { echo 'FATAL ERROR: subsampler pipeline failed;' ; exit 1; }
deactivate
cd ../../

cd ${pipeline_output}/pandora_analysis_pipeline
source venv/bin/activate
bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  --stats pandora_analysis_pipeline_runtime_stats --report pandora_analysis_pipeline_report.zip \
  || { echo 'FATAL ERROR: pandora_analysis_pipeline failed;' ; exit 1; }
deactivate
cd ../../

cd ${pipeline_output}/variant_callers_pipeline
source venv/bin/activate
snakemake --profile lsf --configfile config.pandora_paper_tag1 --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  --keep-going --stats variant_callers_pipeline_runtime_stats --report variant_callers_pipeline_report.zip \
  || { echo 'FATAL ERROR: variant_callers_pipeline failed;' ; exit 1; }
deactivate
cd ../../
