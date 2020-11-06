# paper_pandora2020_analyses

Snakemake pipeline to handle the installation and running of all pipelines in the pandora paper. It also produces all
plots in the paper. 

The version used in the pandora paper has tag `pandora_paper_tag1`.

# Paper plots

If you are interested only on the paper plots package, it can be [viewed here](scripts/csv_to_paper_plots/paper_pandora2020_plots)
or [downloaded here](https://github.com/leoisl/pandora1_paper_full_pipeline/raw/master/scripts/csv_to_paper_plots/paper_pandora2020_plots.zip).

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
recall measurement is biased towards tools that recover core variants well. For this reason, this measure is generally
not considered in the paper, except when it is needed to compute recall restricted to single samples (which is the only
measure defined in this case). To deal with this core variant bias, we have two other measures.

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
proportions instead of counts;

## gene_distance_plots

Provides data about the edit distance between locus sequences in the references (pandora inferred VCF-reference + the other 24 references)
and in the 20 samples.

Main file:

* `gene_sample_ref_ED_nbsamples_zam.csv`

Preview:

```
gene_name,sample,ref,edit_distance,edit_distance_labels,nb_of_samples
GC00003501,063_STEC,NC_011993.1,0.010101010101010102,0.02,20
GC00003501,CFT073,NC_011993.1,0.0,0.01,20
GC00003501,Escherichia_coli_MINF_1A,NC_011993.1,0.060606060606060615,0.07,20
GC00003501,Escherichia_coli_MINF_1D,NC_011993.1,0.0505050505050505,0.060000000000000005,20
```

Fields explanation:

* `gene_name`, `sample`, `ref`, `edit_distance`: self explanatory;
* `nb_of_samples`: the number of samples the given gene was identified in;
* `edit_distance_labels`: ignore;


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
The recall considered here is the Total Allelic Recall (`recall_wrt_truth_probes`), as it is the only defined for a single sample.

Main files: `recall_per_ref_per_clade_{tool}_pandora.csv` , tool == `snippy` or `samtools` or `medaka` or `nanopolish`

## recall_per_ref_per_nb_of_samples_per_clade

Similar to [recall_per_ref_per_clade](#recall_per_ref_per_clade), but we have data split by frequency (or number of samples) the
allele of the pangenome variant is in. The field `nb_of_samples` represent this.

Main files: `recall_per_ref_per_nb_of_samples_per_clade.{tool}_pandora.nb_of_samples_{nb}.csv` , tool == `snippy` or `samtools` or `medaka` or `nanopolish` , `nb` ranges from 2 to 20;

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
The recalls considered here are: i) Pan-Variant Recall (`PVR`, `recall_wrt_variants_where_all_allele_seqs_were_found`);
ii) Average Allelic Recall (`AvgAR`, `recall_wrt_variants_found_wrt_alleles`).

Main files:
* `recall_per_nb_of_samples_pvr.plot_data.csv` (for `PVR`);
* `recall_per_nb_of_samples_avgar.plot_data.csv` (for `AvgAR`);

Preview (for `PVR`, `AvgAR` is similar):

```
coverage,tool,coverage_threshold,strand_bias_threshold,gaps_threshold,NB_OF_SAMPLES,recall,recall_PVR,NUMBER_OF_SAMPLES,total_nb_of_PanVar,nb_of_found_PanVar,cumulative_nb_of_found_PanVar,colour
100x,pandora_illumina_nodenovo_global_genotyping,0,0.0,1.0,2,,0.4584300168900254,2,63351,29041.999999999996,29041.999999999996,orange
100x,pandora_illumina_withdenovo_global_genotyping,0,0.0,1.0,2,,0.4929203958895677,2,63351,31227.000000000004,31227.000000000004,blue
100x,snippy_NC_011993.1,0,Not_App,Not_App,2,,0.30694069549020536,2,63351,19445.0,19445.0,"rgba(255,0,0,0.3)"
```

Fields explanation:

Important fields:

* `tool`: the considered tool;
* `recall_PVR`: the `PVR`;
* `NB_OF_SAMPLES` or `NUMBER_OF_SAMPLES`: represent the recall at the given frequency. Duplicated fields;
* `nb_of_found_PanVar`: the number of pangenomes variations found. Can be used to do the plot with absolute counts;
* `cumulative_nb_of_found_PanVar`: the number of pangenomes variations found cumulatively (i.e. with `NB_OF_SAMPLES` less than the number of samples of this record).
Can be used to do the plot with cumulative absolute counts;

Other fields:

* `total_nb_of_PanVar`: total number of pangenome variations at that frequency;
* `coverage,coverage_threshold,strand_bias_threshold,gaps_threshold`: filtering options;
* `colour`: ignore;
* `recall`: empty field, to be removed;

For `AvgAR`, we have `recall_AvgAR` instead of `recall_PVR`.

## ROC_data.tsv

The ROC data for the considered tools

Preview:
```
	tool	coverage	coverage_threshold	strand_bias_threshold	gaps_threshold	step_GT	error_rate	nb_of_correct_calls	nb_of_total_calls	recalls_wrt_truth_probes	nbs_of_truth_probes_found	nbs_of_truth_probes_in_total	recalls_wrt_variants_where_all_allele_seqs_were_found	recalls_wrt_variants_found_wrt_alleles	nbs_variants_where_all_allele_seqs_were_found	nbs_variants_found_wrt_alleles	nbs_variants_total
0	pandora_illumina_nodenovo_global_genotyping	100x	0	0.0	1.0	0	0.0059087704272498	3857627.6795571432	3880557.0	0.8938190838656083	6208302	6945815	0.7444157818552333	0.8497949421959974	460276	525432.4617344962	618305
1	pandora_illumina_nodenovo_global_genotyping	100x	0	0.0	1.0	1	0.005903728676744491	3857100.4914081306	3880007.0	0.8937897705294634	6206385	6943898	0.7441683311634226	0.8494682071001245	460123	525230.4397910425	618305
2	pandora_illumina_nodenovo_global_genotyping	100x	0	0.0	1.0	2	0.005896919341595419	3856687.518114524	3879565.0	0.8937732947457525	6205308	6942821	0.7438966205998657	0.8492857257272203	459955	525117.6106457689	618305
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


## pangenome_variants_vs_samples

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

* `PANGENOME_VARIATION_ID`: the identifier of the pangenome variation;
* `NUMBER_OF_SAMPLES`: the number of samples the specified pangenome variation is in;


## two_SNP_heatmap

Provides data to build the 2-SNP heatmap (sharing of variants present in precisely 2 genomes).

Main file: `two_SNP_heatmap_count_df.csv` 

Preview:
```
FIRST_SAMPLE,SECOND_SAMPLE,count
063_STEC,063_STEC,0
063_STEC,CFT073,4138
063_STEC,H131800734,67
063_STEC,MINF_1A,1964
```

Fields explanation:

`count` is the number of pangenome variants with frequency 2 found between the `FIRST_SAMPLE` and `SECOND_SAMPLE`.

