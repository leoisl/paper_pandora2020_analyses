import pandas as pd

for nb_of_samples in range(2, 21):
    df = pd.read_csv(f"../pandora1_paper_analysis_output_20_way/illumina_analysis/recall_per_ref_per_nb_of_samples_per_clade/recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.nb_of_samples_{nb_of_samples}.csv")
    df["ref"] = df["ref"].apply(lambda ref: ref.split()[0])
    df.to_csv(f"recall_per_ref_per_nb_of_samples_per_clade.snippy_pandora.nb_of_samples_{nb_of_samples}.simplified.csv", index=False)
