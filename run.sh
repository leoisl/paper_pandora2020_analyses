#!/usr/bin/env bash

# pipeline configuration
zipped_input_data="../zipped_data/data_no_fast5s.zip"
pipeline_output="out"
profile="lsf"


# setup
mkdir -p "$pipeline_output"

# installation
snakemake --snakefile Snakefile_setup --restart-times 0 --profile "$profile" --config zipped_input_data="$zipped_input_data" pipeline_output="$pipeline_output" || { echo 'installation pipeline failed;' ; exit 1; }

# run each pipeline one by one
cd ${pipeline_output}/pangenome_variations
source venv/bin/activate
snakemake --profile lsf --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ || { echo 'pangenome_variations pipeline failed;' ; exit 1; }
deactivate
cd ../../

cd ${pipeline_output}/subsampler
source venv/bin/activate
snakemake --profile lsf --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ || { echo 'subsampler pipeline failed;' ; exit 1; }
deactivate
cd ../../

cd ${pipeline_output}/pandora_analysis_pipeline
source venv/bin/activate
bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ || { echo 'pandora_analysis_pipeline failed;' ; exit 1; }
deactivate
cd ../../

cd ${pipeline_output}/variant_callers_pipeline
source venv/bin/activate
snakemake --profile lsf --configfile config.pandora_paper_tag1.no_nanopolish.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ --keep-going || { echo 'pandora_analysis_pipeline failed;' ; exit 1; }
deactivate
cd ../../
