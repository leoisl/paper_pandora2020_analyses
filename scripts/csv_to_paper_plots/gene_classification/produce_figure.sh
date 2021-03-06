set -eux
cp ../pandora1_paper_analysis_output_20_way/illumina_analysis/FP_genes/pandora_illumina_100x_withdenovo/gene_classification_by_gene_length.csv gene_classification_by_gene_length.illumina.csv
cp ../pandora1_paper_analysis_output_20_way/illumina_analysis/FP_genes/pandora_illumina_100x_withdenovo/gene_classification_by_gene_length_normalised.csv gene_classification_by_gene_length_normalised.illumina.csv
cp ../pandora1_paper_analysis_output_20_way/nanopore_analysis/FP_genes/pandora_nanopore_100x_withdenovo/gene_classification_by_gene_length.csv gene_classification_by_gene_length.nanopore.csv
cp ../pandora1_paper_analysis_output_20_way/nanopore_analysis/FP_genes/pandora_nanopore_100x_withdenovo/gene_classification_by_gene_length_normalised.csv gene_classification_by_gene_length_normalised.nanopore.csv
python preprocess.py
Rscript gene_classification.R
