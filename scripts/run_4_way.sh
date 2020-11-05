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
LOCAL_CORES=20

# setup
mkdir -p "$pipeline_output"

# installation
flag_file="${pipeline_output}/installation_pipeline_done"
if ! test -f "${flag_file}"; then
  echo "Running installation pipeline..."
  cd installation_pipeline
  source venv/bin/activate
  snakemake --restart-times 0 --profile "$profile" --config input_data_folder="$input_data_folder" \
    pipeline_output="$pipeline_output" || { echo 'FATAL ERROR: installation pipeline failed;' ; exit 1; }
  deactivate
  cd ../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping installation pipeline"
fi


# run each pipeline one by one
flag_file="${pipeline_output}/pangenome_variations_pipeline_done"
if ! test -f "${flag_file}"; then
  echo "Running pangenome_variations pipeline..."
  cd ${pipeline_output}/pangenome_variations
  source venv/bin/activate
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way_old_basecall.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
    || { echo 'FATAL ERROR: pangenome_variations pipeline old basecall failed;' ; exit 1; }
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way_new_basecall.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  || {   echo 'FATAL ERROR: pangenome_variations pipeline new basecall failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pangenome_variations_pipeline"
fi



flag_file="${pipeline_output}/subsampler_pipeline_done"
if ! test -f "${flag_file}"; then
  echo "Running subsampler pipeline..."
  cd ${pipeline_output}/subsampler
  source venv/bin/activate
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
    || { echo 'FATAL ERROR: subsampler pipeline for nanopore failed;' ; exit 1; }
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way.illumina.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
    || { echo 'FATAL ERROR: subsampler pipeline for illumina failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping subsampler pipeline"
fi



flag_file="${pipeline_output}/pandora_workflow_old_basecall_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_workflow old basecall..."
  cd ${pipeline_output}/pandora_workflow
  source venv/bin/activate
  bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.4_way_old_basecall.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
    || { echo 'FATAL ERROR: pandora_workflow old basecall failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_workflow old basecall"
fi


flag_file="${pipeline_output}/pandora_workflow_new_basecall_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_workflow new basecall..."
  cd ${pipeline_output}/pandora_workflow
  source venv/bin/activate
  bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.4_way_new_basecall.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
    || { echo 'FATAL ERROR: pandora_workflow new basecall failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_workflow new basecall"
fi


flag_file="${pipeline_output}/pandora_workflow_illumina_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_workflow illumina..."
  cd ${pipeline_output}/pandora_workflow
  source venv/bin/activate
  bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.4_way_illumina.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
    || { echo 'FATAL ERROR: pandora_workflow illumina failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_workflow illumina"
fi


flag_file="${pipeline_output}/pandora1_paper_pipeline_old_basecall_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora1_paper pipeline old basecall..."
  cd ${pipeline_output}/pandora1_paper
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
            --configfile config.pandora_paper_tag1.4_way_old_basecall.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
  || { echo 'FATAL ERROR: pandora1_paper pipeline failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora1_paper pipeline old basecall"
fi


flag_file="${pipeline_output}/pandora1_paper_pipeline_new_basecall_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora1_paper pipeline new basecall..."
  cd ${pipeline_output}/pandora1_paper
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
                --configfile config.pandora_paper_tag1.4_way_new_basecall.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
   || { echo 'FATAL ERROR: pandora1_paper pipeline new basecall failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora1_paper pipeline new basecall"
fi


flag_file="${pipeline_output}/pandora1_paper_pipeline_filters_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora1_paper pipeline with filters..."
  cd ${pipeline_output}/pandora1_paper
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
            --configfile config.pandora_paper_tag1.4_way_pandora_filters.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
   || { echo 'FATAL ERROR: pandora1_paper pipeline with filters failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora1_paper pipeline with filters"
fi


flag_file="${pipeline_output}/pandora1_paper_pipeline_filters_illumina_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora1_paper pipeline with filters for illumina..."
  cd ${pipeline_output}/pandora1_paper
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
            --configfile config.pandora_paper_tag1.4_way_pandora_filters.illumina.yaml --singularity-prefix /hps/nobackup2/singularity/leandro/ \
   || { echo 'FATAL ERROR: pandora1_paper pipeline with filters for illumina failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora1_paper pipeline with filters for illumina"
fi


echo "All done!"
