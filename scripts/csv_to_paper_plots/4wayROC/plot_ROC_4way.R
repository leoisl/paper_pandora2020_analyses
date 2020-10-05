library("ggplot2")

png(file="ROC_data_old_and_new_basecall.png", width=1000, height=500)
four_way_df <- read.csv("ROC_data_old_and_new_basecall.R_data.csv", header=TRUE)

ggplot(data=four_way_df, aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                             group=tool, linetype=methylation_aware, colour=local_assembly)) +
  geom_line() +
  scale_colour_manual(values = c("no"="red", "yes"="blue")) +
  scale_linetype_manual(values = c("no"="dashed", "yes"="solid")) + 
  scale_x_continuous(breaks= seq(0,1,by=0.001)) +
  scale_y_continuous(breaks= seq(0,1,by=0.02)) +
  theme(text = element_text(size=20), legend.position=c(0.85,0.2)) +
  ylab("Average Allelic Recall") +
  xlab("Error Rate")

