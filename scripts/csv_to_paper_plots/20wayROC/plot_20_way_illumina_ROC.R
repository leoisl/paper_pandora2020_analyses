library("ggplot2")


png(file="ROC_data_20_way_illumina.R_data.png", width=700, height=500)

illumina_20_way_df <- read.csv("ROC_data_20_way_illumina.R_data.csv", header=TRUE)

ggplot(data=illumina_20_way_df, aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                             group=tool_long_name, colour=tool)) +
  geom_line() +
  scale_colour_manual(values = c("pandora no denovo"="red", "pandora with denovo"="blue",
                                 "snippy"="darkgreen", samtools="purple")) +
  scale_x_continuous(breaks= seq(0,1,by=0.003)) +
  theme(text = element_text(size=20), legend.position=c(0.85,0.2)) +
  ylim(0.65, 0.90) +
  ylab("Average Allelic Recall") +
  xlab("Error Rate")

dev.off()
