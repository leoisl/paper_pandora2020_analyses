set -eux
python preprocess.py
Rscript plot_ROC_4way.R
