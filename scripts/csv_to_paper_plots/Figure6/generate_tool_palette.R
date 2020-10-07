#Set up colour palette for tool-related graphs
tool_palette_df<- data.frame(palette = c("#440154FF", "#453781CF", "#22A884CF",
                                         "#2A788EFF","#7BA151FF", "#B8DE29FF"),
                             tool = c("medaka", "nanopolish", "pandora no denovo",
                                       "pandora with denovo", "samtools", "snippy"))

write.csv(tool_palette_df, file="tool_palette.csv", row.names = FALSE)
