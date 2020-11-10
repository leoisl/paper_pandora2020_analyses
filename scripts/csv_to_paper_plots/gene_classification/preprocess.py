#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import plotly.express as px


# In[2]:


all_gene_lengths = [str(x) for x in list(range(100, 4200, 100))]

def read_df(filepath):
    df = pd.read_csv(filepath, header=[0,1,2])
    df.columns=["classification"] + [str(i) for i in all_gene_lengths]
    df = pd.melt(df, id_vars=['classification'], value_vars=all_gene_lengths, var_name="gene_length", value_name='count')
    return df

df_illumina = read_df("gene_classification_by_gene_length.illumina.csv")
df_illumina_normalised = read_df("gene_classification_by_gene_length_normalised.illumina.csv")
df_nanopore = read_df("gene_classification_by_gene_length.nanopore.csv")
df_nanopore_normalised = read_df("gene_classification_by_gene_length_normalised.nanopore.csv")


# In[3]:


def get_plot_gene_classification(data, xaxis_title, yaxis_title):
    fig = px.bar(data, x="gene_length", y="count", color="classification")
    fig.update_layout(xaxis_title=xaxis_title, yaxis_title=yaxis_title,
                     font={"size": 20}, width=800, height=500)
    return fig


# In[4]:


plot_illumina = get_plot_gene_classification(
    df_illumina,
    xaxis_title="Locus length",
    yaxis_title="Count")
plot_illumina.write_image("gene_classification_by_gene_length.illumina.png")

plot_illumina_normalised = get_plot_gene_classification(
    df_illumina_normalised,
    xaxis_title="Locus length",
    yaxis_title="Proportion")
plot_illumina_normalised.write_image("gene_classification_by_gene_length_normalised.illumina.png")

plot_nanopore = get_plot_gene_classification(
    df_nanopore,
    xaxis_title="Locus length",
    yaxis_title="Count")
plot_nanopore.write_image("gene_classification_by_gene_length.nanopore.png")

plot_nanopore_normalised = get_plot_gene_classification(
    df_nanopore_normalised,
    xaxis_title="Locus length",
    yaxis_title="Proportion")
plot_nanopore_normalised.write_image("gene_classification_by_gene_length_normalised.nanopore.png")