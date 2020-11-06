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

## Packaging 20- and 4-way results

Scripts `scripts/package_output.sh` and `scripts/package_output_4way.sh` package the 20- and 4-way results, respectively,
computed with the previous commands. It creates two zip packages, `pandora1_paper_analysis_output_20_way.zip` and
`pandora1_paper_analysis_output_4_way.zip`, respectively, containing the data that is needed to reproduce the paper plots 
(and some other additional data).

## Reproducing all plots in the paper from pre-computed results:

The two previously described packages were already pre-computed and made available. To download, extract, and use them 
to create the plots in the paper, please do:

1. `git checkout pandora_paper_tag1`
2. `cd scripts/csv_to_paper_plots && ./generate_paper_plots.sh`


# Package files description

The `pandora1_paper_analysis_output_20_way.zip` package contains data that 
can be reprocessed and replotted. Besides the data, some plots are also included to give a general sense/idea of the data,
and how the plots could look like, but it is by no means the best visualisation of the data. 
In what follows is a short description of each file and its fields, to help on the understanding of the files in these 
packages.

## Preliminaries

### The different types of recall
In many plots regarding recall, we have different ways to measure recall. It is easier to explain them using examples.
Suppose we have three genes, each with one SNP between them. The first gene is rare, present in 2/20 genomes.
The second gene is at an intermediate frequency, in 10/20 genomes.
The third is a strict core gene, present in all genomes.
The SNP in the first gene has alleles `A`, `C` at 50% frequency (1 `A` and 1 `C`).
The SNP in the second gene has alleles `G`, `T` at 50% frequency (5 `G`s and 5 `T`s).
The SNP in the third gene has alleles `A`, `T` with 15 `A`s and 5 `T`s.
Suppose a variant caller found the SNP in the first gene, detecting the two correct alleles.
For the second gene’s SNP, it detected only one `G` and one `T`, failing to detect either allele in the other 8 genomes.
For the third gene's SNP, it detected all the 5 `T`s, but no `A`. Here, the:

* Total Allelic Recall (`TAR`, referenced as `recall_wrt_truth_probes` in the files) would be 
`number of alleles found / number of total alleles = (2+2+5)/(2+10+20) = 0.28`. The main issue with `TAR` is that core
variants contribute to a lot more alleles, and thus weight, in the recall calculation than rare variants. For example,
if we are in a panel with 20 genomes, one core variant can have the same weight as 10 rare variants. This means that our
recall measurement is biased towards tools that recover core variants well. For this reason, this measurement is not
considered in the paper. To deal with this bias, we have two other measures.

* Pan-Variant Recall (`PVR`, referenced as `recall_wrt_variants_where_all_allele_seqs_were_found` in the files) would be:
`(1 + 1 + 0) / 3 = 0.66` - i.e. score a `1` if both alleles are found, irrespective of how often, and `0` otherwise. 
This measure gives the same weight for core and rare variants.

* Average Allelic Recall (`AvgAR`, referenced as `recall_wrt_variants_found_wrt_alleles`) would be:
`(2/2 + 2/10 + 5/20) / 3 = 0.48` - i.e. for each variant, the `number of alleles found / total number of alleles`. 
This is a balance between the two previous measures. It does not overweight core variants (all variants have a
recall value in `[0, 1]`), and it rewards tools finding more alleles of a variant.

For more details, please see the paper manuscript.

## Sequencing-technology-dependent analyses

These folders/files refer to sequencing-technology-dependent analyses, present in the folders
`illumina_analysis`, `illumina_analysis_with_filters`, `nanopore_analysis`, and `nanopore_analysis_with_filters`.
For details about the filters applied in these results, see the Methods section in the paper manuscript.

## enrichment_of_FPs

Provides for each tool and sample, the error rate the pipeline computed for that tool on that sample. Can be mainly used
to check if there is a sample with issue (i.e. a sample where all tools consistently perform bad). These values are not filtered by genotype confidence.

Main file: `enrichment_of_FPs.csv`

Preview:
```
GT,step_GT,precision,error_rate,nb_of_correct_calls,nb_of_total_calls,sample,tool,coverage,coverage_threshold,strand_bias_threshold,gaps_threshold
0,0,0.994254362790382,0.00574563720961796,173504.3460874612,174507.0,063_STEC,pandora_illumina_nodenovo_global_genotyping,100x,0,0.0,1.0
0,0,0.9936651659229959,0.006334834077003859,184938.97335125625,186118.0,CFT073,pandora_illumina_nodenovo_global_genotyping,100x,0,0.0,1.0
0,0,0.9941746924963222,0.005825307503677824,198630.1385126102,199794.0,Escherichia_coli_MINF_1A,pandora_illumina_nodenovo_global_genotyping,100x,0,0.0,1.0
```

Fields explanation:

Important fields:
* `precision` and `error_rate`: the precision and error rate of the tool for that particular sample;
* `sample` and `tool`: the sample and tool took into consideration;

Other fields:
* `GT` and `step_GT`: ignore, not relevant here;
* `nb_of_correct_calls` and `nb_of_total_calls`: raw values used to compute `precision` and `error_rate`;
* `coverage,coverage_threshold,strand_bias_threshold,gaps_threshold`: details about the run;


## FP_genes

Provides data about the amount of FP, TP, FN, and TN loci found by pandora.

Main files:

* `gene_classification.csv`: contains the counts of FP, TP, FN, and TN loci (columns) for pandora in all samples;
* `gene_classification_by_sample.csv`: contains the counts of FP, TP, FN, and TN loci (columns) for pandora in each sample (rows);
* `gene_classification_by_gene_length.csv`: contains the counts of FP, TP, FN, and TN loci (1st column) split by
locus length (remaining columns), from locus up to 100, 200, 300, ... 4100+ bps. The header is composed of the 3 first lines 
(a pandas multirow header);
* `gene_classification_by_gene_length_normalised.csv`: the same as `gene_classification_by_gene_length.csv`, but with
proportion instead of counts;


## precision_per_ref_per_clade

Shows a breakdown of the precision of each tool (snippy, samtools, medaka, etc) against pandora.
We have one plot for each reference the tool used, and the precision on each of the samples.
The background colour is coloured by the reference clade.
Pandora precision is shown as lines.
There is one csv for each tool.

Main files: `precision_per_ref_per_clade_{tool}_pandora.csv` , tool == `snippy` or `samtools` or `medaka` or `nanopolish`

Preview:
```
tool,sample,precision,ref,tool_and_ref
Medaka,Escherichia_coli_MINF_1A,0.831789544979302,C4 (CP010121.1),Medaka / C4 (CP010121.1)
Pandora illumina no denovo,063_STEC,0.994254362790382,PRG,Pandora illumina no denovo / PRG
```

Fields explanation:

* `tool,sample,precision,ref`: self explanatory;
* `tool_and_ref`: tool and ref concatenated


## recall_per_ref_per_clade

Same as [precision_per_ref_per_clade](#precision_per_ref_per_clade), but for recall instead of precision.
The recall considered here is the recall WRT truth probes (as it is the only defined for a single sample).

Main files: `recall_per_ref_per_clade_{tool}_pandora.csv` , tool == `snippy` or `samtools` or `medaka` or `nanopolish`

## recall_per_ref_per_nb_of_samples_per_clade

Similar to [recall_per_ref_per_clade](#recall_per_ref_per_clade), but we have data split by frequency (nb of samples) the
pangenome variant is in. The field `nb_of_samples` represent this.

Main files: `recall_per_ref_per_nb_of_samples_per_clade.{tool}_pandora.nb_of_samples_{nb}.csv` , tool == `snippy` or `samtools` or `medaka` or `nanopolish` , nb ranges from 2 to 20;

## precision_per_sample

The input csv for this (`precision_per_sample.tsv`) is actually the same as [enrichment_of_FPs](#enrichment_of_FPs).
Just the plots are different. Could well be merged.

Main file: `precision_per_sample.tsv`

## recall_per_sample

Similar to [precision_per_sample](#precision_per_sample). It features all the three types of recall discussed on
[The different types of recall](#the-different-types-of-recall). These values are not filtered by genotype confidence.

Main file: `recall_per_sample.tsv`

Preview:
```
GT	step_GT	recalls_wrt_truth_probes	nbs_of_truth_probes_found	nbs_of_truth_probes_in_total	recalls_wrt_variants_where_all_allele_seqs_were_found	recalls_wrt_variants_found_wrt_alleles	nbs_variants_where_all_allele_seqs_were_found	nbs_variants_found_wrt_alleles	nbs_variants_total	tool	coverage	coverage_threshold	strand_bias_threshold	gaps_threshold	sample
0	0	0.8659094229759785	320028	369586	0.0	0.06964684242136669	0	25740.497903143234	369586	samtools_NZ_CP018109.1	100x	0	Not_App	Not_App	Escherichia_coli_MINF_9A
0	0	0.955989627165643	335104	350531	0.0	0.06855860932737412	0	24031.849327524455	350530	samtools_NC_007779.1	100x	0	Not_App	Not_App	H131800734
0	0	0.8728209202393062	325193	372577	0.0	0.06779792683112228	0	25259.609195324887	372572	snippy_NC_022648.1	100x	0	Not_App	Not_App	Escherichia_coli_MSB1_4I
```

Fields explanation:

Important fields:

* `recalls_wrt_truth_probes, recalls_wrt_variants_where_all_allele_seqs_were_found, recalls_wrt_variants_found_wrt_alleles`: the three recall values;
* `tool` and `sample`: the tool and the sample;	
	
Other fields:

* `GT` and `step_GT`: ignore, not relevant here;
* `coverage	coverage_threshold, strand_bias_threshold, gaps_threshold`: the filtering options;
* `nbs_of_truth_probes_found, nbs_of_truth_probes_in_total, nbs_variants_where_all_allele_seqs_were_found, nbs_variants_found_wrt_alleles, nbs_variants_total`: values used to compute the 3 recalls;

## recall_per_nb_of_samples

Data about the recall of each tool split by the pangenome variants frequency (nb of samples a pangenome variant is in).
The recall considered here is the recall WRT pangenome variants sequences.

Main file: `recall_per_nb_of_samples.plot_data.csv` (use this, don't use the unprocessed `recall_per_nb_of_samples.tsv`)

Preview:

```
coverage,tool,coverage_threshold,strand_bias_threshold,gaps_threshold,NB_OF_SAMPLES,recall,NUMBER_OF_SAMPLES,total_nb_of_PanVar,nb_of_found_PanVar,cumulative_nb_of_found_PanVar,colour
100x,pandora_illumina_nodenovo_global_genotyping,0,0.0,1.0,2,0.4584300168900254,2,63351,29041.999999999996,29041.999999999996,orange
100x,pandora_illumina_withdenovo_global_genotyping,0,0.0,1.0,2,0.4929203958895677,2,63351,31227.000000000004,31227.000000000004,blue
100x,pandora_nanopore_nodenovo_global_genotyping,0,0.0,1.0,2,0.456362172657101,2,63351,28911.000000000004,28911.000000000004,orange
```

Fields explanation:

Important fields:

* `tool`: the considered tool;
* `recall`: the recall WRT pangenome variants sequences;
* `NB_OF_SAMPLES` or `NUMBER_OF_SAMPLES`: these are the same, represent the recall if we look at the pangenome variants with this given frequency (nb of samples).
I forgot to remove one of them when merging dataframes;
* `nb_of_found_PanVar`: the number of pangenomes variations found. Can be used to do the plot with absolute counts;
* `cumulative_nb_of_found_PanVar`: the number of pangenomes variations found cumulatively (i.e. with `NB_OF_SAMPLES` less than the number of samples of this record).
Can be used to do the plot with cumulative absolute counts;
* `colour`: the proposed colour for the tool when plotting;

Other fields:

* `total_nb_of_PanVar`: total number of pangenome variations at that frequency;
* `coverage,coverage_threshold,strand_bias_threshold,gaps_threshold`: filtering options;

## recall_per_sample_per_number_of_samples

The same plot as [recall_per_nb_of_samples](#recall_per_nb_of_samples), but further split by samples. Not sure if interesting,
we are not producing a plot related to this data yet.

## ROC_data_all_tools.tsv

The ROC data for all tools, with no filtering.

Preview:
```
	tool	coverage	coverage_threshold	strand_bias_threshold	gaps_threshold	step_GT	error_rate	nb_of_correct_calls	nb_of_total_calls	recalls_wrt_truth_probes	nbs_of_truth_probes_found	nbs_of_truth_probes_in_total	recalls_wrt_variants_where_all_allele_seqs_were_found	recalls_wrt_variants_found_wrt_alleles	nbs_variants_where_all_allele_seqs_were_found	nbs_variants_found_wrt_alleles	nbs_variants_total
0	nanopolish_NC_011993.1	100x	0	Not_App	Not_App	0	0.027808519631150386	1659659.186265035	1707132.0	0.8704078643039009	6045692	6945815	0.7316906704619889	0.7430971094658996	452408	459460.658268313	618305
1	nanopolish_NC_011993.1	100x	0	Not_App	Not_App	1	0.027515085716985015	1658361.0195983683	1705282.0	0.870395381177012	6045023	6945146	0.731441602445395	0.7429713097336729	452254	459382.8756648786	618305
2	nanopolish_NC_011993.1	100x	0	Not_App	Not_App	2	0.027137049410518643	1656782.686265035	1702997.0	0.8703772399712334	6044051	6944174	0.7311743090777352	0.7428044702958294	452088	459278.9752017925	618304
```

Fields explanation:

Important fields:

* `tool,coverage`: the considered tool and the read coverage we used;
* `error_rate,recalls_wrt_truth_probes,recalls_wrt_variants_where_all_allele_seqs_were_found,recalls_wrt_variants_found_wrt_alleles`: the error rate and the 3 recall measures;
* `coverage_threshold,strand_bias_threshold,gaps_threshold`: the filters that were applied;

Other fields:
* `step_GT`: the genotype filtering step used. The lower (higher) the value, the more lenient (strict) the GT filtering was. 0 is unfiltered, and the max value is the max filtering we set for the pipeline;
* `nb_of_correct_calls,nb_of_total_calls,nbs_of_truth_probes_found,nbs_of_truth_probes_in_total,nbs_variants_where_all_allele_seqs_were_found,nbs_variants_found_wrt_alleles,nbs_variants_total`: fields used to compute the error rate and the recalls;


## Sequencing-technology-independent analyses

These folders/files refer to sequencing-technology-independent analyses, present in the folder `technology_independent_analysis`.


## plot_pangenome_variants_vs_samples

Provides data to check how many pangenome variants are in 2, 3, 4, ... samples.

Main file: `pangenome_variations_per_nb_of_samples.csv` 

Preview:
```
PANGENOME_VARIATION_ID,NUMBER_OF_SAMPLES
0,2
1,4
2,2
3,20
```

Fields explanation:

* `PANGENOME_VARIATION_ID`: ignore, it is the identifier of the pangenome variation;
* `NUMBER_OF_SAMPLES`: the number of samples the specified pangenome variation is in;
