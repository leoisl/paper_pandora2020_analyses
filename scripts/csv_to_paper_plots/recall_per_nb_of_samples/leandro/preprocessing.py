#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


df_pvr_illumina = pd.read_csv("../../pandora1_paper_analysis_output_20_way/illumina_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.plot_data.csv")
df_pvr_nanopore = pd.read_csv("../../pandora1_paper_analysis_output_20_way/nanopore_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_pvr.plot_data.csv")
df_avgar_illumina = pd.read_csv("../../pandora1_paper_analysis_output_20_way/illumina_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.plot_data.csv")
df_avgar_nanopore = pd.read_csv("../../pandora1_paper_analysis_output_20_way/nanopore_analysis/recall_per_nb_of_samples/recall_per_nb_of_samples_avgar.plot_data.csv")


# In[3]:


def get_tool_category(tool):
    if "pandora" in tool and "nodenovo" in tool:
        return "pandora no denovo"
    elif "pandora" in tool and "withdenovo" in tool:
        return "pandora with denovo"
    else:
        return tool.split("_")[0]
    
def cleanup_pvr_df(df):
    return df[["tool_long_description", "tool", "NUMBER_OF_SAMPLES", "nb_of_found_PanVar", "recall_PVR"]]
def cleanup_avgar_df(df):
    return df[["tool_long_description", "tool", "NUMBER_OF_SAMPLES", "recall_AvgAR"]]

def process_df(df, pvr):
    # remove nodenovo results
    df = df[df.tool!="pandora_illumina_nodenovo_global_genotyping"]
    df = df[df.tool!="pandora_nanopore_nodenovo_global_genotyping"]
    
    # add tool_category column
    df["tool_long_description"] = df["tool"]
    df["tool"] = df["tool_long_description"].apply(get_tool_category)
    
    if pvr:
        df = cleanup_pvr_df(df)
    else:
        df = cleanup_avgar_df(df)
    
    return df
    
df_pvr_illumina = process_df(df_pvr_illumina, True)
df_pvr_nanopore = process_df(df_pvr_nanopore, True)
df_avgar_illumina = process_df(df_avgar_illumina, False)
df_avgar_nanopore = process_df(df_avgar_nanopore, False)


# In[4]:


# do some merges
df_illumina = df_pvr_illumina.merge(df_avgar_illumina, on=["tool_long_description", "tool", "NUMBER_OF_SAMPLES"])
df_nanopore = df_pvr_nanopore.merge(df_avgar_nanopore, on=["tool_long_description", "tool", "NUMBER_OF_SAMPLES"])


# In[5]:


# save to csvs
df_illumina.to_csv("df_illumina.R_data.csv", index=False)
df_nanopore.to_csv("df_nanopore.R_data.csv", index=False)

