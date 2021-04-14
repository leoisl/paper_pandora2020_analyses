#!/usr/bin/env bash
set -eux

# configuration is done by input
if [ $# -ne 1 ]
  then
    echo "Usage: $0 <pipeline_output>"
    exit 1
fi

filter_file() {
  if [ $1 == "illumina" ]; then
    awk 'BEGIN{IGNORECASE=1} NR == 1 || /illumina|samtools|snippy/' $2 > $3
  else
    awk 'BEGIN{IGNORECASE=1} NR == 1 || /nanopore|medaka|nanopolish/' $2 > $3
  fi
}

run_filters_with_specific_tools() {
  pipeline_output=$1
  output_dir=$2
  technology=$3
  tool=$4
  filter=$5

  for filter in "${filters[@]}"; do
      filter_file "${technology}" \
      "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/precision_per_ref_per_clade/precision_per_ref_per_clade_${tool}_pandora.csv" \
      "${output_dir}/${technology}_analysis${filter}/precision_per_ref_per_clade/precision_per_ref_per_clade_${tool}_pandora.csv"

      filter_file "${technology}" \
      "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/recall_per_ref_per_clade/recall_per_ref_per_clade_${tool}_pandora.csv" \
      "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_clade/recall_per_ref_per_clade_${tool}_pandora.csv"

      for i in {2..20}
      do
        filter_file "${technology}" \
        "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/recall_per_ref_per_nb_of_samples_per_clade/recall_per_ref_per_nb_of_samples_per_clade.${tool}_pandora.nb_of_samples_${i}.csv" \
        "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_nb_of_samples_per_clade/recall_per_ref_per_nb_of_samples_per_clade.${tool}_pandora.nb_of_samples_${i}.csv"
      done
  done
}

# main
pipeline_output=$1
output_dir="pandora1_paper_analysis_output_20_way"
mkdir -p "${output_dir}"

# pangenome variations
mkdir -p "${output_dir}/technology_independent_analysis"
cp -vr "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/plot_pangenome_variants_vs_samples" "${output_dir}/technology_independent_analysis/pangenome_variants_vs_samples"
cp -vr "${pipeline_output}/pangenome_variations/output_pangenome_variations_pandora_paper_tag1/two_SNP_heatmap"                    "${output_dir}/technology_independent_analysis/two_SNP_heatmap"


# illumina/nanopore analysis
technologies=("illumina" "nanopore")
# filters=("" "_with_filters")
filters=("")
for technology in "${technologies[@]}"; do
  for filter in "${filters[@]}"; do
    mkdir -p "${output_dir}/${technology}_analysis${filter}"
    mkdir -p "${output_dir}/${technology}_analysis${filter}/enrichment_of_FPs"
    mkdir -p "${output_dir}/${technology}_analysis${filter}/precision_per_ref_per_clade"
    mkdir -p "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_clade"
    mkdir -p "${output_dir}/${technology}_analysis${filter}/precision_per_sample"
    mkdir -p "${output_dir}/${technology}_analysis${filter}/recall_per_sample"
    mkdir -p "${output_dir}/${technology}_analysis${filter}/recall_per_nb_of_samples"
    mkdir -p "${output_dir}/${technology}_analysis${filter}/recall_per_ref_per_nb_of_samples_per_clade"

    # pandora paper roc
    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/enrichment_of_FPs/enrichment_of_FPs.csv" \
    "${output_dir}/${technology}_analysis${filter}/enrichment_of_FPs/enrichment_of_FPs.csv"

    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/precision_per_sample/precision_per_sample.tsv" \
    "${output_dir}/${technology}_analysis${filter}/precision_per_sample/precision_per_sample.tsv"

    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/recall_per_sample/recall_per_sample.tsv" \
    "${output_dir}/${technology}_analysis${filter}/recall_per_sample/recall_per_sample.tsv"

    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.plot_data.csv" \
    "${output_dir}/${technology}_analysis${filter}/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.plot_data.csv"

    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv" \
    "${output_dir}/${technology}_analysis${filter}/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"

    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.plot_data.csv" \
    "${output_dir}/${technology}_analysis${filter}/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.plot_data.csv"

    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv" \
    "${output_dir}/${technology}_analysis${filter}/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"

    filter_file "${technology}" \
    "${pipeline_output}/pandora_paper_roc/analysis_output_pandora_paper_tag1${filter}/plot_data/ROC_data.tsv" \
    "${output_dir}/${technology}_analysis${filter}/ROC_data.tsv"


  #  # pandora_gene_distance
  #  if [ "$filter" = "" ]
  #  then
  #    mkdir -p "${output_dir}/${technology}_analysis/FP_genes"
  #    cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_nodenovo"
  #    cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/FP_genes/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/FP_genes/pandora_${technology}_100x_withdenovo"
  #    mkdir -p "${output_dir}/${technology}_analysis/gene_distance_plots"
  #    cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_nodenovo"   "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_nodenovo"
  #    cp -vr "${pipeline_output}/pandora_gene_distance/gene_distance_pandora_paper_tag1/gene_distance_plots/pandora_${technology}_100x_withdenovo" "${output_dir}/${technology}_analysis/gene_distance_plots/pandora_${technology}_100x_withdenovo"
  #  fi
  done
done

illumina_tools=("samtools" "snippy")
nanopore_tools=("medaka" "nanopolish")
for filter in "${filters[@]}"; do
  run_filters_with_specific_tools "${pipeline_output}" "${output_dir}" "illumina" "samtools" "${filter}"
  run_filters_with_specific_tools "${pipeline_output}" "${output_dir}" "illumina" "snippy" "${filter}"
  run_filters_with_specific_tools "${pipeline_output}" "${output_dir}" "nanopore" "medaka" "${filter}"
  run_filters_with_specific_tools "${pipeline_output}" "${output_dir}" "nanopore" "nanopolish" "${filter}"
done

# remove uninteresting csvs
#rm -v "${output_dir}/illumina_analysis/FP_genes/pandora_illumina_100x_nodenovo/gene_and_nb_of_FPs_counted.csv"
#rm -v "${output_dir}/illumina_analysis/FP_genes/pandora_illumina_100x_withdenovo/gene_and_nb_of_FPs_counted.csv"
#rm -v "${output_dir}/nanopore_analysis/FP_genes/pandora_nanopore_100x_nodenovo/gene_and_nb_of_FPs_counted.csv"
#rm -v "${output_dir}/nanopore_analysis/FP_genes/pandora_nanopore_100x_withdenovo/gene_and_nb_of_FPs_counted.csv"
#
#rm -v "${output_dir}/illumina_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"
#rm -v "${output_dir}/illumina_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"
#rm -v "${output_dir}/nanopore_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"
#rm -v "${output_dir}/nanopore_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.tsv"
#
#rm -v "${output_dir}/illumina_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"
#rm -v "${output_dir}/illumina_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"
#rm -v "${output_dir}/nanopore_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"
#rm -v "${output_dir}/nanopore_analysis_with_filters/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.tsv"


# create the package
zip -r "${output_dir}.zip" "${output_dir}"
echo "Package available at ${output_dir}.zip"
