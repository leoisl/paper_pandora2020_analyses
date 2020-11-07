#!/usr/bin/env bash
set -eux

mkdir paper_pandora2020_code
cd paper_pandora2020_code

download_repo () {
  URL=$1
  git clone --depth 1 --branch pandora_paper_tag1 "$URL"
}

# Note: we did not include make_prg, as it is copied inside the pandora_workflow pipeline
download_repo https://github.com/rmcolq/pandora
download_repo https://github.com/iqbal-lab-org/varifier
download_repo https://github.com/iqbal-lab-org/pangenome_variations
download_repo https://github.com/iqbal-lab-org/subsampler
download_repo https://github.com/iqbal-lab-org/pandora_workflow
download_repo https://github.com/iqbal-lab-org/variant_callers_pipeline
download_repo https://github.com/leoisl/vcf_consensus_builder
download_repo https://github.com/iqbal-lab-org/pandora_paper_roc
download_repo https://github.com/iqbal-lab-org/pandora_gene_distance
# download_repo https://github.com/leoisl/paper_pandora2020_analyses  # TODO: uncomment this and move to iqbal-lab-org once public

# package
cd ..
zip -r paper_pandora2020_code.zip paper_pandora2020_code
