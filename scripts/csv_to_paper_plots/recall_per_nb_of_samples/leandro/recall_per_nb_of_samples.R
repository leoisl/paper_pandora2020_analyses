library("ggplot2")

df_illumina <- read.csv("df_illumina.R_data.csv", header=TRUE)
df_nanopore <- read.csv("df_nanopore.R_data.csv", header=TRUE)



png(file="recall_per_nb_of_samples.illumina.nb_of_found_panvars.png", width=700, height=400)

ggplot(df_illumina, aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar, fill=tool)) +
  geom_boxplot(data = df_illumina[df_illumina$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool), colour=tool),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_illumina[df_illumina$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#999999", "#E69F00")) +
  ylab("Number of Pan-variants found") +
  xlab("Number of Samples")

dev.off()



png(file="recall_per_nb_of_samples.illumina.recall_PVR.png", width=700, height=400)

ggplot(df_illumina, aes(x=NUMBER_OF_SAMPLES, y=recall_PVR, fill=tool)) +
  geom_boxplot(data = df_illumina[df_illumina$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool), colour=tool),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_illumina[df_illumina$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=recall_PVR),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#999999", "#E69F00")) +
  ylab("Pan-variants Recall") +
  xlab("Number of Samples")



png(file="recall_per_nb_of_samples.illumina.recall_AvgAR.png", width=700, height=400)
ggplot(df_illumina, aes(x=NUMBER_OF_SAMPLES, y=recall_AvgAR, fill=tool)) +
  geom_boxplot(data = df_illumina[df_illumina$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool), colour=tool),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_illumina[df_illumina$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=recall_AvgAR),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#999999", "#E69F00")) +
  ylab("Average Allelic Recall") +
  xlab("Number of Samples")


dev.off()
