set -eux
bash preprocess.sh
Rscript Figure10.R illumina
Rscript Figure10.R nanopore
