#!/usr/bin/env bash
set -eu

# configuration is done by input
if [ $# -ne 1 ]
  then
    echo "Usage: $0 <pipeline_output>"
    exit 1
fi

pipeline_output=$1

output_dir="pandora1_paper_analysis_output_4_way"
mkdir -p "${output_dir}"

# old vs new basecalling
sed "s/pandora/pandora_OLD_BASECALL/g" "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1_4way_old_basecall/plot_data/ROC_data.tsv" > "${output_dir}/ROC_data_old_basecall.tsv"
sed "s/pandora/pandora_NEW_BASECALL/g" "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1_4way_new_basecall/plot_data/ROC_data.tsv" > "${output_dir}/ROC_data_new_basecall.tsv"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
python "${script_dir}/concat_ROCs.py" "${output_dir}/ROC_data_old_basecall.tsv" "${output_dir}/ROC_data_new_basecall.tsv" --output "${output_dir}/ROC_data_old_and_new_basecall.tsv"

# filters
cp "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1_4way_new_basecall_with_filters/plot_data/ROC_data.tsv"          "${output_dir}/ROC_data_new_basecall.nanopore.with_filters.tsv"
cp "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1_4way_new_basecall_with_filters_illumina/plot_data/ROC_data.tsv" "${output_dir}/ROC_data_new_basecall.illumina.with_filters.tsv"

zip -r "${output_dir}.zip" "${output_dir}"
