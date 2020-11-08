#!/usr/bin/env bash
set -eux

mkdir paper_pandora2020_code
cd paper_pandora2020_code

download_and_package_repo () {
  URL=$1
  name=$2
  git clone --depth 1 --branch pandora_paper_tag1 "$URL"
  zip -r "$name.zip" "$name"
}

# Note: we did not include make_prg, as it is copied inside the pandora_workflow pipeline
download_and_package_repo https://github.com/rmcolq/pandora pandora
download_and_package_repo https://github.com/iqbal-lab-org/varifier varifier
download_and_package_repo https://github.com/iqbal-lab-org/pangenome_variations pangenome_variations
download_and_package_repo https://github.com/iqbal-lab-org/subsampler subsampler
download_and_package_repo https://github.com/iqbal-lab-org/pandora_workflow pandora_workflow
download_and_package_repo https://github.com/iqbal-lab-org/variant_callers_pipeline variant_callers_pipeline
download_and_package_repo https://github.com/leoisl/vcf_consensus_builder vcf_consensus_builder
download_and_package_repo https://github.com/iqbal-lab-org/pandora_paper_roc pandora_paper_roc
download_and_package_repo https://github.com/iqbal-lab-org/pandora_gene_distance pandora_gene_distance
# download_and_package_repo https://github.com/iqbal-lab-org/paper_pandora2020_analyses  # TODO: uncomment this when repo goes public

