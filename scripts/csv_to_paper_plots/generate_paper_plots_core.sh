#!/usr/bin/env bash
set -eu

package_20_way_URL="https://www.dropbox.com/s/6yhixedsj2u61ii/pandora1_paper_analysis_output_20_way.zip?dl=1"
package_4_way_URL="https://www.dropbox.com/s/1vfucxsnt8k5jfo/pandora1_paper_analysis_output_4_way.zip?dl=1"

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

mkdir -p paper_pandora2020_plots

echo "Generating Figure 1..."
cd gene_frequency_distribution && bash produce_figure.sh && cd ..
cp gene_frequency_distribution/gene_frequency_distribution.png paper_pandora2020_plots/Figure1.png

echo "Generating Figure 2..."
cp pandora_workflow/pandora_workflow.png paper_pandora2020_plots/Figure2.png

echo "Generating Figure 3..."
cp representation_problem/representation_problem.png paper_pandora2020_plots/Figure3.png

echo "Generating Figure 4..."
cp 20_way_tree/20_way_tree.png paper_pandora2020_plots/Figure4.png

echo "Generating Figures 5, SF1, SF2..."
cd recall_per_nb_of_samples && ls -1 && bash produce_figure.sh && cd ..
cp recall_per_nb_of_samples/recall_per_number_of_samples_nanopore.png paper_pandora2020_plots/Figure5.png
cp recall_per_nb_of_samples/recall_per_number_of_samples_all.png paper_pandora2020_plots/SupplementaryFigure1.png
cp recall_per_nb_of_samples/recall_per_number_of_samples_all_avgar.png paper_pandora2020_plots/SupplementaryFigure2.png

echo "Generating Figure 6, SF3, SF4..."
cd precision_recall && bash produce_figure.sh && cd ..
cp precision_recall/precision_recall.png paper_pandora2020_plots/Figure6.png
cp precision_recall/precision_recall_with_filters.png paper_pandora2020_plots/SupplementaryFigure3.png
cp precision_recall/precision_recall_with_pvr.png paper_pandora2020_plots/SupplementaryFigure4.png

echo "Generating Figure 7..."
cd recall_per_ref_per_clade_simplified && bash produce_figure.sh && cd ..
cp recall_per_ref_per_clade_simplified/recall_per_ref_per_clade_simplified.png paper_pandora2020_plots/Figure7.png

echo "Generating Figure 8..."
cd two_SNP_heatmap && bash produce_figure.sh && cd ..
cp two_SNP_heatmap/two_SNP_heatmap.png paper_pandora2020_plots/Figure8.png

echo "Generating Figure 9, SF5..."
cd gene_distance && bash produce_figure.sh && cd ..
cp gene_distance/loci_ref_sample_approximation_ed_1.png paper_pandora2020_plots/Figure9.png
cp gene_distance/loci_ref_sample_approximation_ed_0.png paper_pandora2020_plots/SupplementaryFigure5.png

echo "Generating SF6..."
cd gene_classification && bash produce_figure.sh && cd ..
cp gene_classification/gene_classification.png paper_pandora2020_plots/SupplementaryFigure6.png

echo "Generating SF7-11..."
cd recall_per_ref_per_clade_complete && bash produce_figure.sh && cd ..
cp recall_per_ref_per_clade_complete/recall_per_ref_per_clade_snippy_pandora.png paper_pandora2020_plots/SupplementaryFigure7.png
cp recall_per_ref_per_clade_complete/recall_per_ref_per_clade_samtools_pandora.png paper_pandora2020_plots/SupplementaryFigure8.png
cp recall_per_ref_per_clade_complete/recall_per_ref_per_clade_medaka_pandora.png paper_pandora2020_plots/SupplementaryFigure9.png
cp recall_per_ref_per_clade_complete/recall_per_ref_per_clade_nanopolish_pandora.png paper_pandora2020_plots/SupplementaryFigure10.png
cp recall_per_ref_per_clade_complete/recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.nb_of_samples_2.png paper_pandora2020_plots/SupplementaryFigure11.png

echo "Generating SF12"
cp pangenome_variants/pangenome_variants.png paper_pandora2020_plots/SupplementaryFigure12.png

echo "Generating SF13..."
cd 4wayROC && bash produce_figure.sh && cd ..
cp 4wayROC/ROC_data_old_and_new_basecall.png paper_pandora2020_plots/SupplementaryFigure13.png

echo "Generating SA1"
cp rcc/rcc.mov paper_pandora2020_plots/SupplementaryAnimation1.mov

echo "Generating SA2"
cd pandora_vs_snippy_recall_by_freq && bash produce_figure.sh && cd ..
cp pandora_vs_snippy_recall_by_freq/recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.gif paper_pandora2020_plots/SupplementaryAnimation2.gif

echo "Generating package..."
zip -r paper_pandora2020_plots.zip paper_pandora2020_plots

echo "All done! See dir paper_pandora2020_plots or package paper_pandora2020_plots.zip"
