import pandas as pd
import gzip
from Bio import SeqIO
from pathlib import Path
import argparse

#############################################################################
#  helper functions
def update_to_absolute_path_core(path_series):
    return path_series.apply(lambda path: str(Path(path).absolute()))
def update_to_absolute_path(df, columns):
    for column in columns:
        df[column] = update_to_absolute_path_core(df[column])
    return df


def get_number_of_bases(handle, filetype):
    number_of_bases = 0
    for record in SeqIO.parse(handle, filetype):
        number_of_bases += len(record.seq)
    return number_of_bases


def get_coverage(reads, reference):
    number_of_bases_in_reads = []
    for read_file in reads:
        with gzip.open(read_file, "rt") as handle:
            number_of_bases_in_reads.append(get_number_of_bases(handle, "fastq"))

    with open(reference, "r") as handle:
        number_of_bases_in_reference = get_number_of_bases(handle, "fasta")

    return sum(number_of_bases_in_reads) / number_of_bases_in_reference
#############################################################################


def get_args():
    parser = argparse.ArgumentParser(description='Compute illumina and nanopore read coverages.')
    parser.add_argument('--samples_csv', type=str, help='Path to a file with the samples ids and paths', required=True)
    args = parser.parse_args()
    return args

def main():
    args = get_args()

    df = pd.read_csv(args.samples_csv)
    df = update_to_absolute_path(df, ["sample_path"])

    illumina_coverages = []
    nanopore_coverages = []
    for sample_id, sample_path in zip(df.sample_id, df.sample_path):
        illumina_coverage = get_coverage([f"{sample_path}/{sample_id}.illumina_1.fastq.gz",
                                          f"{sample_path}/{sample_id}.illumina_2.fastq.gz"],
                                          f"{sample_path}/{sample_id}.ref.fa")
        illumina_coverages.append(round(illumina_coverage, 1))

        nanopore_coverage = get_coverage([f"{sample_path}/{sample_id}.nanopore.fastq.gz"],
                                          f"{sample_path}/{sample_id}.ref.fa")
        nanopore_coverages.append(round(nanopore_coverage, 1))

    coverage_df = pd.DataFrame({
        "sample_id": df.sample_id,
        "illumina_coverage": illumina_coverages,
        "nanopore_coverage": nanopore_coverages
    })
    coverage_df.to_csv("read_coverages.csv", index=False)


if __name__=="__main__":
    main()
