import pandas as pd
import sys
csvfile = sys.argv[1]
df1 = pd.read_csv(csvfile)
df1 = df1[~df1["tool"].str.contains("no denovo")]
df1["tool"] = [s.split()[0].lower() for s in df1["tool"] if "no denovo" not in s]

csvfile = sys.argv[2]
df2 = pd.read_csv(csvfile)
df2 = df2[~df2["tool"].str.contains("andora")]  # it is actually Pandora, but putting "andora" to be "case insensitive"
df2["tool"] = [s.split()[0].lower() for s in df2["tool"] if "no denovo" not in s]

illumina_df = pd.concat([df1, df2])
illumina_df["sample"] = [
    s.replace("Escherichia_coli_", "") for s in illumina_df["sample"]
]
illumina_df.to_csv(sys.argv[3], index=False)

csvfile = sys.argv[4]
df1 = pd.read_csv(csvfile)
df1 = df1[~df1["tool"].str.contains("no denovo")]
df1["tool"] = [s.split()[0].lower() for s in df1["tool"] if "no denovo" not in s]

csvfile = sys.argv[5]
df2 = pd.read_csv(csvfile)
df2 = df2[~df2["tool"].str.contains("andora")]
df2["tool"] = [s.split()[0].lower() for s in df2["tool"] if "no denovo" not in s]

ontdf = pd.concat([df1, df2])
ontdf["sample"] = [s.replace("Escherichia_coli_", "") for s in ontdf["sample"]]
ontdf.to_csv(sys.argv[6], index=False)


