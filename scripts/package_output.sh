#!/usr/bin/env bash
set -eu

# TODO: input need to receive two pipeline outputs (one from normal run, another from 4way)

# configuration is done by input
if [ $# -ne 1 ]
  then
    echo "Usage: $0 <pipeline_output>"
    exit 1
fi

pipeline_output=$1

mkdir -p pandora1_paper_analysis_output
ln -s "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/plot_pangenome_variants_vs_samples" pandora1_paper_analysis_output/plot_pangenome_variants_vs_samples
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/enrichment_of_FPs" pandora1_paper_analysis_output/enrichment_of_FPs
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/precision_per_ref_per_clade" pandora1_paper_analysis_output/precision_per_ref_per_clade
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/precision_per_sample" pandora1_paper_analysis_output/precision_per_sample
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/recall_per_nb_of_samples" pandora1_paper_analysis_output/recall_per_nb_of_samples
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/recall_per_ref_per_clade" pandora1_paper_analysis_output/recall_per_ref_per_clade
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/recall_per_ref_per_nb_of_samples_per_clade" pandora1_paper_analysis_output/recall_per_ref_per_nb_of_samples_per_clade
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/recall_per_sample" pandora1_paper_analysis_output/recall_per_sample
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/recall_per_sample_per_number_of_samples" pandora1_paper_analysis_output/recall_per_sample_per_number_of_samples
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1/plot_data/ROC_data.tsv" pandora1_paper_analysis_output/ROC_data_all_tools.tsv
ln -s "${pipeline_output}/pandora1_paper/analysis_output_pandora_filters_pandora_paper_tag1/plot_data/ROC_data.tsv" pandora1_paper_analysis_output/ROC_data_pandora_only_with_filters.tsv

# TODO: add code to merge the 4way ROCs

# TODO: add gene distance plots here

zip -r pandora1_paper_analysis_output.zip pandora1_paper_analysis_output
