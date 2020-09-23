# Pandora paper full pipeline

Snakemake pipeline to handle the installation and running of all pipelines in the pandora paper. 

The version used in the pandora paper has tag `pandora_paper_tag1`.

# Running

## Requirements

### Dependencies
* python 3.6+;
* singularity 2.4.1+;

## Setting up the installation pipeline
```
cd installation_pipeline && ./setup.sh
```

## Running on the paper data on an LSF cluster:

1. `git checkout pandora_paper_tag1`
2. `scripts/submit_lsf.sh <input_data_folder> <pipeline_output>`

# Output files description

This pipeline produces a package in the end with data that can be reprocessed and replotted.
This is a short description of each file and its fields.

## enrichment_of_FPs

Provides for each tool and sample, the error rate the pipeline computed for that tool on that sample. Can be mainly used
to check if there is a sample with issue (i.e. a sample where all tools consistently perform bad).  

Main file: `enrichment_of_FPs.csv`

Preview:
```
GT,step_GT,precision,error_rate,nb_of_correct_calls,nb_of_total_calls,sample,tool,coverage,coverage_threshold,strand_bias_threshold,gaps_threshold
0,0,0.994254362790382,0.00574563720961796,173504.3460874612,174507.0,063_STEC,pandora_illumina_nodenovo_global_genotyping,100x,0,0.0,1.0
0,0,0.9936651659229959,0.006334834077003859,184938.97335125625,186118.0,CFT073,pandora_illumina_nodenovo_global_genotyping,100x,0,0.0,1.0
0,0,0.9941746924963222,0.005825307503677824,198630.1385126102,199794.0,Escherichia_coli_MINF_1A,pandora_illumina_nodenovo_global_genotyping,100x,0,0.0,1.0
```

Fields explanation:
* `GT` and `step_GT`: ignore, not relevant here;
* `precision` and `error_rate`: the precision and error rate of the tool for that particular sample;
* `nb_of_correct_calls` and `nb_of_total_calls`: raw values used to compute `precision` and `error_rate`;
* `sample` and `tool`: the sample and tool took into consideration;
* `coverage,coverage_threshold,strand_bias_threshold,gaps_threshold`: details about the run;

