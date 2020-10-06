import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import cm
import seaborn as sns

plt.style.use("ggplot")

csvfile = "../pandora1_paper_analysis_output_20_way/illumina_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_samtools_pandora.csv"
df1 = pd.read_csv(csvfile)
df1 = df1[~df1["tool"].str.contains("no denovo")]
df1["tool"] = [s.split()[0].lower() for s in df1["tool"] if "no denovo" not in s]

csvfile = "../pandora1_paper_analysis_output_20_way/illumina_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_snippy_pandora.csv"
df2 = pd.read_csv(csvfile)
df2 = df2[~df2["tool"].str.contains("andora")]  # it is actually Pandora, but putting "andora" to be "case insensitive"
df2["tool"] = [s.split()[0].lower() for s in df2["tool"] if "no denovo" not in s]

illumina_df = pd.concat([df1, df2])
illumina_df["sample"] = [
    s.replace("Escherichia_coli_", "") for s in illumina_df["sample"]
]

csvfile = "../pandora1_paper_analysis_output_20_way/nanopore_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_medaka_pandora.csv"
df1 = pd.read_csv(csvfile)
df1 = df1[~df1["tool"].str.contains("no denovo")]
df1["tool"] = [s.split()[0].lower() for s in df1["tool"] if "no denovo" not in s]

csvfile = "../pandora1_paper_analysis_output_20_way/nanopore_analysis_with_filters/precision_per_ref_per_clade/precision_per_ref_per_clade_nanopolish_pandora.csv"
df2 = pd.read_csv(csvfile)
df2 = df2[~df2["tool"].str.contains("andora")]
df2["tool"] = [s.split()[0].lower() for s in df2["tool"] if "no denovo" not in s]

ontdf = pd.concat([df1, df2])
ontdf["sample"] = [s.replace("Escherichia_coli_", "") for s in ontdf["sample"]]

fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(14, 6), dpi=100)
x = "sample"
y = "precision"
hue = "tool"
palette = "Set1"

sns.pointplot(
    data=illumina_df.query("tool == 'pandora'"),
    x=x,
    y=y,
    ax=ax[0],
    hue=hue,
    palette=cm.Set1.colors[2:3],
)
sns.boxenplot(
    data=illumina_df.query("tool != 'pandora'"),
    x=x,
    y=y,
    hue=hue,
    palette=palette,
    ax=ax[0],
    showfliers=False,
    k_depth="full",
)
ax[0].set(ylabel="Precision", xlabel="Sample", title="Illumina")

sns.pointplot(
    data=ontdf.query("tool == 'pandora'"),
    x=x,
    y=y,
    ax=ax[1],
    hue=hue,
    palette=cm.Set1.colors[2:3],
)
sns.boxenplot(
    data=ontdf.query("tool != 'pandora'"),
    x=x,
    y=y,
    hue=hue,
    palette=palette,
    ax=ax[1],
    showfliers=False,
    k_depth="full",
)
ax[1].set(xlabel="Sample", title="Nanopore", ylabel="")

for axis in ax:
    # Turn on the minor TICKS, which are required for the minor GRID
    axis.minorticks_on()

    # Customize the major grid
    axis.grid(which="major", linestyle="-", linewidth="0.5")
    # Customize the minor grid
    axis.grid(which="minor", linestyle="--", linewidth="0.25", alpha=0.5, axis="y")

fig.autofmt_xdate(rotation=45)
fig.savefig("precision_per_sample.png")
