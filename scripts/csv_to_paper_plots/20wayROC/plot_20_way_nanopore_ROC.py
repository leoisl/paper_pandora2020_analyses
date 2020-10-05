#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import os


# In[2]:

import sys
df = pd.read_csv(sys.argv[1], sep="\t")
df


# In[3]:


# add some custom columns
df["tool_long_name"] = df["tool"]

def get_tool_category(tool):
    if tool == "pandora_nanopore_nodenovo_global_genotyping":
        return "pandora no denovo"
    elif tool == "pandora_nanopore_withdenovo_global_genotyping":
        return "pandora with denovo"
    else:
        return tool.split("_")[0]

df["tool"] = df["tool_long_name"].apply(get_tool_category)
df


# In[4]:


# run R script
df.to_csv("ROC_data_20_way_nanopore.R_data.csv")
os.system("Rscript plot_20_way_nanopore_ROC.R")
