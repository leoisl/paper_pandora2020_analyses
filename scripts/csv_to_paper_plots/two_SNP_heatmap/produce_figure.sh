set -eux
cp ../pandora1_paper_analysis_output_20_way/technology_independent_analysis/two_SNP_heatmap/two_SNP_heatmap_count_df.csv .
Rscript two_SNP_heatmap.R
