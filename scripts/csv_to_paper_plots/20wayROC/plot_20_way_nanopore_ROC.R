library("ggplot2")


png(file="ROC_data_20_way_nanopore.R_data.png", width=1000, height=500)

df <- read.csv("ROC_data_20_way_nanopore.R_data.csv", header=TRUE)

ggplot(data=df, aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                             group=tool_long_name, colour=tool)) +
  geom_line() +
  scale_colour_manual(values = c("pandora no denovo"="red", "pandora with denovo"="blue",
                                 "medaka"="orange", "nanopolish"="pink")) +
  theme(text = element_text(size=20), legend.position=c(0.85,0.2)) +
  xlim(0.0, 0.2) + 
  ylab("Average Allelic Recall") +
  xlab("Error Rate")

