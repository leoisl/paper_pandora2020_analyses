#!/usr/bin/env bash

# pipeline configuration is done by input
if [ $# -ne 5 ]
  then
    echo "Usage: $0 <singularity_prefix> <local_cores> <profile> <input_data_folder> <pipeline_output>"
    exit 1
fi

singularity_prefix=$1
LOCAL_CORES=$2
profile=$3
input_data_folder=$4
pipeline_output=$5

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
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way_old_basecall.yaml --singularity-prefix "${singularity_prefix}" \
    || { echo 'FATAL ERROR: pangenome_variations pipeline old basecall failed;' ; exit 1; }
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way_new_basecall.yaml --singularity-prefix "${singularity_prefix}" \
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
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way.yaml --singularity-prefix "${singularity_prefix}" \
    || { echo 'FATAL ERROR: subsampler pipeline for nanopore failed;' ; exit 1; }
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.4way.illumina.yaml --singularity-prefix "${singularity_prefix}" \
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
  bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.4_way_old_basecall.yaml --singularity-prefix "${singularity_prefix}" \
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
  bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.4_way_new_basecall.yaml --singularity-prefix "${singularity_prefix}" \
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
  bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.4_way_illumina.yaml --singularity-prefix "${singularity_prefix}" \
    || { echo 'FATAL ERROR: pandora_workflow illumina failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_workflow illumina"
fi


flag_file="${pipeline_output}/pandora_paper_roc_pipeline_old_basecall_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_paper_roc pipeline old basecall..."
  cd ${pipeline_output}/pandora_paper_roc
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
            --configfile config.pandora_paper_tag1.4_way_old_basecall.yaml --singularity-prefix "${singularity_prefix}" \
  || { echo 'FATAL ERROR: pandora_paper_roc pipeline failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_paper_roc pipeline old basecall"
fi


flag_file="${pipeline_output}/pandora_paper_roc_pipeline_new_basecall_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_paper_roc pipeline new basecall..."
  cd ${pipeline_output}/pandora_paper_roc
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
                --configfile config.pandora_paper_tag1.4_way_new_basecall.yaml --singularity-prefix "${singularity_prefix}" \
   || { echo 'FATAL ERROR: pandora_paper_roc pipeline new basecall failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_paper_roc pipeline new basecall"
fi


flag_file="${pipeline_output}/pandora_paper_roc_pipeline_filters_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_paper_roc pipeline with filters..."
  cd ${pipeline_output}/pandora_paper_roc
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
            --configfile config.pandora_paper_tag1.4_way_pandora_filters.yaml --singularity-prefix "${singularity_prefix}" \
   || { echo 'FATAL ERROR: pandora_paper_roc pipeline with filters failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_paper_roc pipeline with filters"
fi


flag_file="${pipeline_output}/pandora_paper_roc_pipeline_filters_illumina_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_paper_roc pipeline with filters for illumina..."
  cd ${pipeline_output}/pandora_paper_roc
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" --keep-going \
            --configfile config.pandora_paper_tag1.4_way_pandora_filters.illumina.yaml --singularity-prefix "${singularity_prefix}" \
   || { echo 'FATAL ERROR: pandora_paper_roc pipeline with filters for illumina failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_paper_roc pipeline with filters for illumina"
fi


echo "All done!"
