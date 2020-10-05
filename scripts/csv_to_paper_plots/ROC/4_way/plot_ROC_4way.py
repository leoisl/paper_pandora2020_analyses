#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import os


# In[2]:


# read df
import sys
four_way_df = pd.read_csv(sys.argv[1], sep="\t")


# In[3]:


# add new columns
four_way_df["methylation_aware"] = four_way_df["tool"].apply(lambda tool: "yes" if tool.startswith("pandora_NEW_BASECALL") else "no")
four_way_df["local_assembly"] = four_way_df["tool"].apply(lambda tool: "yes" if "withdenovo" in tool else "no")


# In[4]:


# plot with R
four_way_df.to_csv("ROC_data_old_and_new_basecall.R_data.csv")
os.system("Rscript plot_ROC_4way.R")
os.remove("ROC_data_old_and_new_basecall.R_data.csv")

