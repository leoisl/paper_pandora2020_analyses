#!/usr/bin/env bash
set -eu

package_20_way_URL="https://www.dropbox.com/s/dan82zlh9vwdqqo/pandora1_paper_analysis_output_20_way_07_10_2020.zip?dl=1"
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
cd 4wayROC && bash produce_figure.sh && cd ..
cp 4wayROC/ROC_data_old_and_new_basecall.png paper_plots/Figure5.png

echo "Generating Figure 6..."
cd Figure6 && bash produce_figure.sh && cd ..
cp Figure6/Figure6.png paper_plots/Figure6.png

echo "Generating Figure 8..."
cd Figure8 && bash produce_figure.sh && cd ..
cp Figure8/Figure8.png paper_plots/Figure8.png

echo "All done! See dir paper_plots"