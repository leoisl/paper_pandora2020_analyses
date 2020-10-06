library("ggplot2")


png(file="precision_per_sample_illumina.png", width=700, height=400)

precision_per_sample_illumina_df <- read.csv("precision_per_sample_illumina.csv", header=TRUE)

ggplot(precision_per_sample_illumina_df, aes(x = sample, y = precision)) + 
  geom_boxplot(data = precision_per_sample_illumina_df[precision_per_sample_illumina_df$tool != "pandora", ],
               aes(group = interaction(sample, tool), colour=tool)) +
  geom_line(data = precision_per_sample_illumina_df[precision_per_sample_illumina_df$tool == "pandora", ], aes(group=tool, colour=tool)) +
  scale_colour_manual(values = c("pandora"="blue", "snippy"="darkgreen", "samtools"="purple")) +
  ylab("Precision") +
  xlab("Sample") +
  theme_minimal() +
  theme(text = element_text(size=20), axis.text.x = element_text(angle = 45), legend.position=c(0.95,0.23))

dev.off()



png(file="precision_per_sample_nanopore.png", width=700, height=400)

precision_per_sample_nanopore_df <- read.csv("precision_per_sample_nanopore.csv", header=TRUE)

ggplot(precision_per_sample_nanopore_df, aes(x = sample, y = precision)) + 
  geom_boxplot(data = precision_per_sample_nanopore_df[precision_per_sample_nanopore_df$tool != "pandora", ],
               aes(group = interaction(sample, tool), colour=tool)) +
  geom_line(data = precision_per_sample_nanopore_df[precision_per_sample_nanopore_df$tool == "pandora", ], aes(group=tool, colour=tool)) +
  scale_colour_manual(values = c("pandora"="blue", "medaka"="orange", "nanopolish"="brown4")) +
  theme_minimal() +
  theme(text = element_text(size=20), axis.text.x = element_text(angle = 45), legend.position=c(0.95,0.23)) +
  ylab("Precision") +
  xlab("Sample")

dev.off()
