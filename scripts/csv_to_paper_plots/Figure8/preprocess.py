import pandas as pd

df = pd.read_csv("../pandora1_paper_analysis_output_20_way/illumina_analysis/recall_per_ref_per_clade/recall_per_ref_per_clade_snippy_pandora.csv")
df["ref"] = df["ref"].apply(lambda ref: ref.split()[0])
df.to_csv("recall_per_ref_per_clade_snippy_pandora.simplified.csv", index=False)

df = pd.read_csv("../pandora1_paper_analysis_output_20_way/illumina_analysis/recall_per_ref_per_nb_of_samples_per_clade/recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.nb_of_samples_2.csv")
df["ref"] = df["ref"].apply(lambda ref: ref.split()[0])
df.to_csv("recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.nb_of_samples_2.simplified.csv", index=False)
