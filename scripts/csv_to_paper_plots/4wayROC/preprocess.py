#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import os


# In[2]:


# read df
import sys
four_way_df = pd.read_csv("../pandora1_paper_analysis_output_4_way/ROC_data_old_and_new_basecall.tsv", sep="\t")


# In[3]:


# add new columns
four_way_df["methylation_aware"] = four_way_df["tool"].apply(lambda tool: "yes" if tool.startswith("pandora_NEW_BASECALL") else "no")
four_way_df["local_assembly"] = four_way_df["tool"].apply(lambda tool: "yes" if "withdenovo" in tool else "no")


# In[4]:


# save csv
four_way_df.to_csv("ROC_data_old_and_new_basecall.R_data.csv")
