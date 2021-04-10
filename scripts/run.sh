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
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.yaml --singularity-prefix "${singularity_prefix}" \
    || { echo 'FATAL ERROR: pangenome_variations pipeline failed;' ; exit 1; }
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
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.yaml --singularity-prefix "${singularity_prefix}" \
    || { echo 'FATAL ERROR: subsampler pipeline failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping subsampler pipeline"
fi



flag_file="${pipeline_output}/pandora_workflow_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_workflow..."
  cd ${pipeline_output}/pandora_workflow
  source venv/bin/activate
  bash scripts/run_pipeline_lsf.sh --configfile config.pandora_paper_tag1.yaml --singularity-prefix "${singularity_prefix}" \
    || { echo 'FATAL ERROR: pandora_workflow failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_workflow"
fi



flag_file="${pipeline_output}/variant_callers_pipeline_done"
if ! test -f "${flag_file}"; then
  echo "Running variant_callers_pipeline..."
  cd ${pipeline_output}/variant_callers_pipeline
  source venv/bin/activate
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.yaml --singularity-prefix "${singularity_prefix}" \
    --keep-going --stats variant_callers_pipeline_runtime_stats || { echo 'FATAL ERROR: variant_callers_pipeline failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping variant_callers_pipeline"
fi



flag_file="${pipeline_output}/pandora_paper_roc_pipeline_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_paper_roc pipeline..."
  cd ${pipeline_output}/pandora_paper_roc
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" \
    --groups calculate_precision_per_sample_no_gt_conf=group_1 calculate_recall_per_sample_no_gt_conf_filter=group_2 calculate_recall_per_sample_vs_nb_of_samples=group_3 create_precision_report_from_probe_mappings=group_4 create_recall_report_for_truth_variants_mappings=group_5 create_recall_report_per_sample_for_calculator=group_6 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_medaka=group_7 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_nanopolish=group_8 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_samtools=group_9 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_snippy=group_10 fix_medaka_vcf_for_pipeline=group_11 fix_nanopolish_vcf_for_pipeline=group_12 fix_samtools_vcf_for_pipeline=group_13 fix_snippy_vcf_for_pipeline=group_14 make_mutated_vcf_ref_for_recall=group_15 make_variant_calls_probeset_for_precision=group_16 make_vcf_for_a_single_sample=group_17 map_recall_truth_probeset_to_mutated_vcf_ref=group_18 map_variant_call_probeset_to_reference_assembly=group_19 \
    --group-components group_1=10 group_2=10 group_3=10 group_4=10 group_5=10 group_6=5 group_7=10 group_8=10 group_9=10 group_10=10 group_11=10 group_12=10 group_13=10 group_14=10 group_15=10 group_16=10 group_17=10 group_18=10 group_19=10 \
    --configfile config.pandora_paper_tag1.yaml --singularity-prefix "${singularity_prefix}" \
  || { echo 'FATAL ERROR: pandora_paper_roc pipeline failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_paper_roc pipeline"
fi



flag_file="${pipeline_output}/pandora_paper_roc_pipeline_filters_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_paper_roc pipeline with filters..."
  cd ${pipeline_output}/pandora_paper_roc
  source venv/bin/activate
  snakemake --local-cores "$LOCAL_CORES" --profile "$profile" \
    --groups calculate_precision_per_sample_no_gt_conf=group_1 calculate_recall_per_sample_no_gt_conf_filter=group_2 calculate_recall_per_sample_vs_nb_of_samples=group_3 create_precision_report_from_probe_mappings=group_4 create_recall_report_for_truth_variants_mappings=group_5 create_recall_report_per_sample_for_calculator=group_6 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_medaka=group_7 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_nanopolish=group_8 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_samtools=group_9 filter_vcf_for_a_single_sample_by_gt_conf_percentile_for_snippy=group_10 fix_medaka_vcf_for_pipeline=group_11 fix_nanopolish_vcf_for_pipeline=group_12 fix_samtools_vcf_for_pipeline=group_13 fix_snippy_vcf_for_pipeline=group_14 make_mutated_vcf_ref_for_recall=group_15 make_variant_calls_probeset_for_precision=group_16 make_vcf_for_a_single_sample=group_17 map_recall_truth_probeset_to_mutated_vcf_ref=group_18 map_variant_call_probeset_to_reference_assembly=group_19 \
    --group-components group_1=10 group_2=10 group_3=10 group_4=10 group_5=10 group_6=5 group_7=10 group_8=10 group_9=10 group_10=10 group_11=10 group_12=10 group_13=10 group_14=10 group_15=10 group_16=10 group_17=10 group_18=10 group_19=10 \
    --configfile config.pandora_paper_tag1.filters.yaml --singularity-prefix "${singularity_prefix}" \
  || { echo 'FATAL ERROR: pandora_paper_roc pipeline failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_paper_roc pipeline with filters"
fi



flag_file="${pipeline_output}/pandora_gene_distance_pipeline_done"
if ! test -f "${flag_file}"; then
  echo "Running pandora_gene_distance pipeline..."
  cd ${pipeline_output}/pandora_gene_distance
  source venv/bin/activate
  snakemake --profile "$profile" --configfile config.pandora_paper_tag1.yaml --singularity-prefix "${singularity_prefix}" \
  || { echo 'FATAL ERROR: pandora_gene_distance pipeline failed;' ; exit 1; }
  deactivate
  cd ../../
  touch "${flag_file}"  # marks this pipeline as done
else
  echo "Skipping pandora_gene_distance pipeline"
fi

echo "All done!"
