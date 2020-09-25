#!/usr/bin/env bash
set -eu

# configuration is done by input
if [ $# -ne 1 ]
  then
    echo "Usage: $0 <pipeline_output>"
    exit 1
fi

pipeline_output=$1

mkdir -p pandora1_paper_4way_output
cp "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1_4way_old_basecall/plot_data/ROC_data.tsv" pandora1_paper_4way_output/ROC_data_old_basecall.tsv
cp "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1_4way_new_basecall/plot_data/ROC_data.tsv" pandora1_paper_4way_output/ROC_data_new_basecall.tsv
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
python "${script_dir}/concat_ROCs.py" pandora1_paper_4way_output/ROC_data_old_basecall.tsv pandora1_paper_4way_output/ROC_data_new_basecall.tsv --output pandora1_paper_4way_output/ROC_data_old_and_new_basecall.tsv
cp "${pipeline_output}/pandora1_paper/analysis_output_pandora_paper_tag1_4way_new_basecall_with_filters/plot_data/ROC_data.tsv" pandora1_paper_4way_output/ROC_data_new_basecall.with_filters.tsv

zip -r pandora1_paper_4way_output.zip pandora1_paper_4way_output
