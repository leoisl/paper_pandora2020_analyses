#!/usr/bin/env bash
set -eu

# configuration is done by input
if [ $# -ne 1 ]
  then
    echo "Usage: $0 <pipeline_output>"
    exit 1
fi

pipeline_output=$1

output_dir="pandora1_paper_analysis_output_20_way"
mkdir -p "${output_dir}"

# pangenome variations
mkdir -p "${output_dir}/technology_independent_analysis"
ln -s "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/plot_pangenome_variants_vs_samples" "${output_dir}/technology_independent_analysis/pangenome_variants_vs_samples"
ln -s "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/two_SNP_heatmap"                    "${output_dir}/technology_independent_analysis/two_SNP_heatmap"


# illumina/nanopore analysis
technologies=("illumina" "nanopore")
filters=("" "_with_filters")
for technology in "${technologies[@]}"; do
  for filter in "${filters[@]}"; do
    mkdir -p "${output_dir}/${technology}_analysis${filter}"

    # pandora 1 paper
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/enrichment_of_FPs"                          "${output_dir}/${technology}_analysis${filter}/enrichment_of_FPs"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/precision_per_ref_per_clade"                "${output_dir}/${technology}_analysis${filter}/precision_per_ref_per_clade"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/precision_per_sample"                       "${output_dir}/${technology}_analysis${filter}/precision_per_sample"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_nb_of_samples"                   "${output_dir}/${technology}_analysis${filter}/recall_per_nb_of_samples"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_ref_per_clade"                   "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_clade"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_ref_per_nb_of_samples_per_clade" "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_nb_of_samples_per_clade"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_sample"                          "${output_dir}/${technology}_analysis${filter}/recall_per_sample"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_sample_per_number_of_samples"    "${output_dir}/${technology}_analysis${filter}/recall_per_sample_per_number_of_samples"
    ln -s "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/ROC_data.tsv"                               "${output_dir}/${technology}_analysis${filter}/ROC_data.tsv"

    # pandora_gene_distance
    if [ "$filter" = "" ]
    then
      mkdir -p "${output_dir}/${technology}_analysis/FP_genes"
      ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_nodenovo"
      ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_withdenovo"
      mkdir -p "${output_dir}/${technology}_analysis/gene_distance_plots"
      ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_nodenovo"
      ln -s "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_withdenovo"
    fi
  done
done


zip -r "${output_dir}.zip" "${output_dir}"
echo "Package available at ${output_dir}.zip"
