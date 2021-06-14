#!/usr/bin/env bash
set -eux

# downloading containers
mkdir -p containers
cd containers

singularity pull docker://leandroishilima/varifier:pandora_paper_tag1
singularity pull docker://leandroishilima/subsampler:pandora_paper_tag1
singularity pull docker://leandroishilima/pandora_analysis_pipeline:pandora_paper_tag1
singularity pull docker://quay.io/biocontainers/snippy:4.6.0--0
singularity pull docker://leandroishilima/variant_callers_pipeline_samtools:pandora_paper_tag1
singularity pull docker://quay.io/biocontainers/medaka:1.0.3--py36hcc5cce8_0
singularity pull docker://leandroishilima/variant_callers_pipeline_nanopolish:pandora_paper_tag1
singularity pull docker://leandroishilima/pandora1_paper_basic_tools:pandora_paper_tag1
singularity pull docker://leandroishilima/pandora1_paper_r:pandora_paper_tag1
singularity pull docker://leandroishilima/pandora_gene_distance_indexing_mapping:pandora_paper_tag1
singularity pull docker://leandroishilima/pandora1_paper_full_pipeline_r_container:pandora_paper_tag1

# renaming to the repo names used in the publication
mv varifier-pandora_paper_tag1.simg varifier.simg
mv subsampler-pandora_paper_tag1.simg subsampler.simg
mv pandora_analysis_pipeline-pandora_paper_tag1.simg pandora_workflow.simg
mv variant_callers_pipeline_samtools-pandora_paper_tag1.simg samtools.simg
mv variant_callers_pipeline_nanopolish-pandora_paper_tag1.simg nanopolish.simg
mv pandora1_paper_basic_tools-pandora_paper_tag1.simg pandora_roc_basic_tools.simg
mv pandora1_paper_r-pandora_paper_tag1.simg pandora_roc_r.simg
mv pandora_gene_distance_indexing_mapping-pandora_paper_tag1.simg pandora_gene_distance_indexing_mapping.simg
mv pandora1_paper_full_pipeline_r_container-pandora_paper_tag1.simg paper_pandora2020_analyses_r_container.simg
