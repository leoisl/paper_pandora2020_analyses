#!/usr/bin/env bash
set -eu

# configuration is done by input
if [ $# -ne 2 ]
  then
    echo "Usage: $0 <pipeline_output> <name_of_the_output_package>"
    exit 1
fi

pipeline_output=$1
output_dir=$2

mkdir -p "${output_dir}"

# pangenome variations
mkdir -p "${output_dir}/technology_independent_analysis"
ln -s "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/plot_pangenome_variants_vs_samples" "${output_dir}/technology_independent_analysis/pangenome_variants_vs_samples"
ln -s "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/two_SNP_heatmap"                    "${output_dir}/technology_independent_analysis/two_SNP_heatmap"


# illumina/nanopore analysis
technologies=("illumina" "nanopore")
for technology in "${technologies[@]}"; do
  mkdir -p "${output_dir}/${technology}_analysis"

  # pandora 1 paper
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/enrichment_of_FPs"                          "${output_dir}/${technology}_analysis/enrichment_of_FPs"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/precision_per_ref_per_clade"                "${output_dir}/${technology}_analysis/precision_per_ref_per_clade"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/precision_per_sample"                       "${output_dir}/${technology}_analysis/precision_per_sample"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/recall_per_nb_of_samples"                   "${output_dir}/${technology}_analysis/recall_per_nb_of_samples"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/recall_per_ref_per_clade"                   "${output_dir}/${technology}_analysis/recall_per_ref_per_clade"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/recall_per_ref_per_nb_of_samples_per_clade" "${output_dir}/${technology}_analysis/recall_per_ref_per_nb_of_samples_per_clade"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/recall_per_sample"                          "${output_dir}/${technology}_analysis/recall_per_sample"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/recall_per_sample_per_number_of_samples"    "${output_dir}/${technology}_analysis/recall_per_sample_per_number_of_samples"
  ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1/plot_data/ROC_data.tsv"                               "${output_dir}/${technology}_analysis/ROC_data.tsv"
  # TODO: change this to be the filters on all tools, not only pandora
  # ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_filters_pandora_paper_tag1/plot_data/ROC_data.tsv"               "${output_dir}/${technology}_analysis/ROC_data_pandora_only_with_filters.tsv

  # pandora_gene_distance
  mkdir -p "${output_dir}/${technology}_analysis/FP_genes"
  ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_nodenovo"
  ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_withdenovo"
  mkdir -p "${output_dir}/${technology}_analysis/gene_distance_plots"
  ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_nodenovo"
  ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_withdenovo"
done


zip -r "${output_dir}.zip" "${output_dir}"
