set -eux
Rscript generate_tool_palette.R

# produce Figure 6
python preprocess_20_way_illumina_ROC.py \
  ../pandora1_paper_analysis_output_20_way/illumina_analysis/ROC_data.tsv \
  ROC_data_20_way_illumina.R_data.csv
python preprocess_20_way_nanopore_ROC.py \
  ../pandora1_paper_analysis_output_20_way/nanopore_analysis/ROC_data.tsv \
  ROC_data_20_way_nanopore.R_data.csv
python preprocess_precision_per_sample.py \
  ../pandora1_paper_analysis_output_20_way/illumina_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_samtools_pandora.csv \
  ../pandora1_paper_analysis_output_20_way/illumina_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_snippy_pandora.csv \
  precision_per_sample_illumina.csv \
  ../pandora1_paper_analysis_output_20_way/nanopore_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_medaka_pandora.csv \
  ../pandora1_paper_analysis_output_20_way/nanopore_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_nanopolish_pandora.csv \
  precision_per_sample_nanopore.csv
Rscript Figure6.R \
  ROC_data_20_way_illumina.R_data.csv \
  ROC_data_20_way_nanopore.R_data.csv \
  precision_per_sample_illumina.csv \
  precision_per_sample_nanopore.csv \
  Figure6.png


# produce filtered Figure 6 (supplementary)
python preprocess_20_way_illumina_ROC.py \
  ../pandora1_paper_analysis_output_20_way/illumina_analysis_with_filters/ROC_data.tsv \
  ROC_data_20_way_illumina_with_filters.R_data.csv
python preprocess_20_way_nanopore_ROC.py \
  ../pandora1_paper_analysis_output_20_way/nanopore_analysis_with_filters/ROC_data.tsv \
  ROC_data_20_way_nanopore_with_filters.R_data.csv
python preprocess_precision_per_sample.py \
  ../pandora1_paper_analysis_output_20_way/illumina_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_samtools_pandora.csv \
  ../pandora1_paper_analysis_output_20_way/illumina_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_snippy_pandora.csv \
  precision_per_sample_illumina_with_filters.csv \
  ../pandora1_paper_analysis_output_20_way/nanopore_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_medaka_pandora.csv \
  ../pandora1_paper_analysis_output_20_way/nanopore_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_nanopolish_pandora.csv \
  precision_per_sample_nanopore_with_filters.csv
Rscript Figure6.R \
  ROC_data_20_way_illumina_with_filters.R_data.csv \
  ROC_data_20_way_nanopore_with_filters.R_data.csv \
  precision_per_sample_illumina_with_filters.csv \
  precision_per_sample_nanopore_with_filters.csv \
  Figure6_supplementary.png
