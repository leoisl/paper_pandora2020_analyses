library("ggplot2")


png(file="ROC_data_20_way_nanopore.R_data.png", width=700, height=500)

nanopore_20_way_df <- read.csv("ROC_data_20_way_nanopore.R_data.csv", header=TRUE)

ggplot(data=nanopore_20_way_df, aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                             group=tool_long_name, colour=tool)) +
  geom_line() +
  scale_colour_manual(values = c("pandora no denovo"="red", "pandora with denovo"="blue",
                                 "medaka"="orange", "nanopolish"="brown4")) +
  theme_minimal() +
  theme(text = element_text(size=20), legend.position=c(0.85,0.2)) +
  xlim(0.0, 0.2) +
  ylim(0.65, 0.90) +
  ylab("Average Allelic Recall") +
  xlab("Error Rate")

dev.off()
