set -eux
cd leandro && \
  python preprocessing.py && \
  Rscript recall_per_nb_of_samples.R && \
  cd ..