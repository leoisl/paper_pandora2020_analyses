#!/usr/bin/env bash
set -eu

package_20_way_URL="https://www.dropbox.com/s/lf3ngwr7g7xwyf8/pandora1_paper_analysis_output_20_way_03_10_2020.zip?dl=1"
package_4_way_URL="https://www.dropbox.com/s/1jurbe31tgjv1oh/pandora1_paper_analysis_output_4_way_28_09_2020.zip?dl=1"

if [ ! -d "pandora1_paper_analysis_output_20_way" ]
then
    echo "Creating pandora1_paper_analysis_output_20_way ..."
    wget "$package_20_way_URL" -O pandora1_paper_analysis_output_20_way.zip
    unzip pandora1_paper_analysis_output_20_way.zip
fi

if [ ! -d "pandora1_paper_analysis_output_4_way" ]
then
    echo "Creating pandora1_paper_analysis_output_4_way ..."
    wget "$package_4_way_URL" -O pandora1_paper_analysis_output_4_way.zip
    unzip pandora1_paper_analysis_output_4_way.zip
fi

mkdir -p paper_plots

echo "Generating Figure 5..."
cd 4wayROC && python plot_ROC_4way.py             ../pandora1_paper_analysis_output_4_way/ROC_data_old_and_new_basecall.tsv && cd ..
cp 4wayROC/ROC_data_old_and_new_basecall.png paper_plots/Figure5.png

echo "Generating Figure 6..."
cd 20wayROC && python plot_20_way_illumina_ROC.py ../pandora1_paper_analysis_output_20_way/illumina_analysis/ROC_data.tsv && cd ..
cd 20wayROC && python plot_20_way_nanopore_ROC.py ../pandora1_paper_analysis_output_20_way/nanopore_analysis/ROC_data.tsv && cd ..
cd precision_per_sample && python precision_per_sample.py && cd ..
cd Figure6 && Rscript Figure6.R && cd ..
cp Figure6/Figure6.png paper_plots/Figure6.png

echo "All done! See dir paper_plots"