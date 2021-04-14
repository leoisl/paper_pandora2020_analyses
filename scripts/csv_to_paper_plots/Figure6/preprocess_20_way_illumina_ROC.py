#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd

# In[2]:

import sys
df = pd.read_csv(sys.argv[1], sep="\t")
df


# In[3]:


# add some custom columns
df["tool_long_name"] = df["tool"]

def get_tool_category(tool):
    if tool == "pandora_illumina_nodenovo":
        return "pandora no denovo"
    elif tool == "pandora_illumina_withdenovo":
        return "pandora with denovo"
    else:
        return tool.split("_")[0]

df["tool"] = df["tool_long_name"].apply(get_tool_category)
df


# In[4]:


# save csv
df.to_csv(sys.argv[2])
