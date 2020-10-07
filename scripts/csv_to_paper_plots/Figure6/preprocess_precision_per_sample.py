import pandas as pd

csvfile = "../pandora1_paper_analysis_output_20_way/illumina_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_samtools_pandora.csv"
df1 = pd.read_csv(csvfile)
df1 = df1[~df1["tool"].str.contains("no denovo")]
df1["tool"] = [s.split()[0].lower() for s in df1["tool"] if "no denovo" not in s]

csvfile = "../pandora1_paper_analysis_output_20_way/illumina_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_snippy_pandora.csv"
df2 = pd.read_csv(csvfile)
df2 = df2[~df2["tool"].str.contains("andora")]  # it is actually Pandora, but putting "andora" to be "case insensitive"
df2["tool"] = [s.split()[0].lower() for s in df2["tool"] if "no denovo" not in s]

illumina_df = pd.concat([df1, df2])
illumina_df["sample"] = [
    s.replace("Escherichia_coli_", "") for s in illumina_df["sample"]
]
illumina_df.to_csv("precision_per_sample_illumina.csv", index=False)

csvfile = "../pandora1_paper_analysis_output_20_way/nanopore_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_medaka_pandora.csv"
df1 = pd.read_csv(csvfile)
df1 = df1[~df1["tool"].str.contains("no denovo")]
df1["tool"] = [s.split()[0].lower() for s in df1["tool"] if "no denovo" not in s]

csvfile = "../pandora1_paper_analysis_output_20_way/nanopore_analysis/precision_per_ref_per_clade/precision_per_ref_per_clade_nanopolish_pandora.csv"
df2 = pd.read_csv(csvfile)
df2 = df2[~df2["tool"].str.contains("andora")]
df2["tool"] = [s.split()[0].lower() for s in df2["tool"] if "no denovo" not in s]

ontdf = pd.concat([df1, df2])
ontdf["sample"] = [s.replace("Escherichia_coli_", "") for s in ontdf["sample"]]
ontdf.to_csv("precision_per_sample_nanopore.csv", index=False)


