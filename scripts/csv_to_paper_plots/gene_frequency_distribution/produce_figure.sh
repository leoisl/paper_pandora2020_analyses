set -eux

cd real_example && Rscript real_example.R && cd ..
Rscript gene_frequency_distribution_figure.R
