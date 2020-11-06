set -eux
python preprocessing.py
Rscript recall_per_nb_of_samples.R
