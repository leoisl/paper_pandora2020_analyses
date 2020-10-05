library("ggplot2")


png(file="ROC_data_20_way_illumina.R_data.png", width=700, height=500)

df <- read.csv("ROC_data_20_way_illumina.R_data.csv", header=TRUE)

ggplot(data=df, aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                             group=tool_long_name, colour=tool)) +
  geom_line() +
  scale_colour_manual(values = c("pandora no denovo"="red", "pandora with denovo"="blue",
                                 "snippy"="darkgreen", samtools="purple")) +
  scale_x_continuous(breaks= seq(0,1,by=0.003)) +
  theme(text = element_text(size=20), legend.position=c(0.85,0.2)) +
  ylab("Average Allelic Recall") +
  xlab("Error Rate")

