library(ggplot2)

count_df <- read.csv("two_SNP_heatmap_count_df.csv", header=TRUE)

png(file="two_SNP_heatmap.png", width=1000, height=1000)

ggplot(count_df, aes(FIRST_SAMPLE, SECOND_SAMPLE, fill=count)) +
  geom_tile() + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90)) +
  ylab("") +
  xlab("")

dev.off()
