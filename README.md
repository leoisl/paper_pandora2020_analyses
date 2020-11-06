# paper_pandora2020_analyses

Snakemake pipeline to handle the installation and running of all pipelines in the pandora paper. It also produces all
plots in the paper. 

The version used in the pandora paper has tag `pandora_paper_tag1`.

# Running

## Requirements

### Dependencies
* python 3.6+;
* singularity 2.4.1+;

## Setting up the installation pipeline (do this if you want to run the pipeline)
```
cd installation_pipeline && ./setup.sh
```

## Running on the paper data on an LSF cluster (on 20-way):

1. `git checkout pandora_paper_tag1`
2. `scripts/submit_lsf.sh <input_data_folder> <pipeline_output>`

## Running on the paper data on an LSF cluster (on 4-way):

1. `git checkout pandora_paper_tag1`
2. `scripts/submit_lsf_4_way.sh <input_data_folder> <pipeline_output>`

## Reproducing all plots in the paper from pre-computed results:

1. `git checkout pandora_paper_tag1`
2. `cd scripts/csv_to_paper_plots && ./generate_paper_plots.sh`
