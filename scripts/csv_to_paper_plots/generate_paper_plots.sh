#!/usr/bin/env bash

cd 4wayROC && python plot_ROC_4way.py             ../pandora1_paper_analysis_output_4_way/ROC_data_old_and_new_basecall.tsv && cd ..
cd 20wayROC && python plot_20_way_illumina_ROC.py ../pandora1_paper_analysis_output_20_way/illumina_analysis/ROC_data.tsv && cd ..
cd 20wayROC && python plot_20_way_nanopore_ROC.py ../pandora1_paper_analysis_output_20_way/nanopore_analysis/ROC_data.tsv && cd ..