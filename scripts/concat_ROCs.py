import pandas as pd
import argparse

parser = argparse.ArgumentParser(description='Concatenate ROCs.')
parser.add_argument('ROCs', metavar='ROC.tsv', type=str, nargs='+',
                    help='.tsv ROCs produced by the ROC pipeline.')
parser.add_argument('--output', type=str, help='Where to write the output concatenated ROC.', required=True)
args = parser.parse_args()

dfs = [pd.read_csv(roc, sep="\t") for roc in args.ROCs]

for df in dfs:
    if 'Unnamed: 0' in df.columns:
        df.drop(['Unnamed: 0'], axis=1, inplace=True)

merged_df = pd.concat(dfs, ignore_index=True)
merged_df.to_csv(args.output, sep="\t")
