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
cp -vr "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/plot_pangenome_variants_vs_samples" "${output_dir}/technology_independent_analysis/pangenome_variants_vs_samples"
cp -vr "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/two_SNP_heatmap"                    "${output_dir}/technology_independent_analysis/two_SNP_heatmap"


# illumina/nanopore analysis
technologies=("illumina" "nanopore")
filters=("" "_with_filters")
for technology in "${technologies[@]}"; do
  for filter in "${filters[@]}"; do
    mkdir -p "${output_dir}/${technology}_analysis${filter}"

    # pandora 1 paper
    cp -vr "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/enrichment_of_FPs"                          "${output_dir}/${technology}_analysis${filter}/enrichment_of_FPs"
    cp -vr "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/precision_per_ref_per_clade"                "${output_dir}/${technology}_analysis${filter}/precision_per_ref_per_clade"
    cp -vr "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/precision_per_sample"                       "${output_dir}/${technology}_analysis${filter}/precision_per_sample"
    cp -vr "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_nb_of_samples"                   "${output_dir}/${technology}_analysis${filter}/recall_per_nb_of_samples"
    cp -vr "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_ref_per_clade"                   "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_clade"
    cp -vr "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_ref_per_nb_of_samples_per_clade" "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_nb_of_samples_per_clade"
    cp -vr "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/recall_per_sample"                          "${output_dir}/${technology}_analysis${filter}/recall_per_sample"
    cp -v "${pipeline_output}/pandora1_paper/analysis_output_${technology}_pandora_paper_tag1${filter}/plot_data/ROC_data.tsv"                               "${output_dir}/${technology}_analysis${filter}/ROC_data.tsv"

    # pandora_gene_distance
    if [ "$filter" = "" ]
    then
      mkdir -p "${output_dir}/${technology}_analysis/FP_genes"
      cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_nodenovo"
      cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_withdenovo"
      mkdir -p "${output_dir}/${technology}_analysis/gene_distance_plots"
      cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_nodenovo"
      cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_withdenovo"
    fi
  done
done


# remove uninteresting csvs
rm -v "${output_dir}/illumina_analysis/FP_genes/pandora_illumina_100x_nodenovo/gene_and_nb_of_FPs_counted.csv"
rm -v "${output_dir}/illumina_analysis/FP_genes/pandora_illumina_100x_withdenovo/gene_and_nb_of_FPs_counted.csv"
rm -v "${output_dir}/nanopore_analysis/FP_genes/pandora_nanopore_100x_nodenovo/gene_and_nb_of_FPs_counted.csv"
rm -v "${output_dir}/nanopore_analysis/FP_genes/pandora_nanopore_100x_withdenovo/gene_and_nb_of_FPs_counted.csv"

rm -v "${output_dir}/illumina_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"
rm -v "${output_dir}/illumina_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"
rm -v "${output_dir}/nanopore_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"
rm -v "${output_dir}/nanopore_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"

rm -v "${output_dir}/illumina_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"
rm -v "${output_dir}/illumina_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"
rm -v "${output_dir}/nanopore_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"
rm -v "${output_dir}/nanopore_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"


# create the package
zip -r "${output_dir}.zip" "${output_dir}"
echo "Package available at ${output_dir}.zip"
