library("ggplot2")

df_illumina <- read.csv("df_illumina.R_data.csv", header=TRUE)
df_illumina$NUMBER_OF_SAMPLES <- as.factor(df_illumina$NUMBER_OF_SAMPLES)
df_nanopore <- read.csv("df_nanopore.R_data.csv", header=TRUE)
df_nanopore$NUMBER_OF_SAMPLES <- as.factor(df_nanopore$NUMBER_OF_SAMPLES)


# TODO: this can be probably done in a for loop (need someone better at R though)
png(file="recall_per_nb_of_samples.illumina.nb_of_found_panvars.png", width=700, height=400)

ggplot(df_illumina, aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar, fill=tool)) +
  geom_boxplot(data = df_illumina[df_illumina$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool)),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_illumina[df_illumina$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#7BA151FF", "#B8DE29FF")) +
  theme(text = element_text(size=20)) +
  ylim(0, 80000) +
  ylab("Number of Pan-variants found") +
  xlab("Number of Samples")

dev.off()



png(file="recall_per_nb_of_samples.illumina.recall_PVR.png", width=700, height=400)

ggplot(df_illumina, aes(x=NUMBER_OF_SAMPLES, y=recall_PVR, fill=tool)) +
  geom_boxplot(data = df_illumina[df_illumina$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool)),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_illumina[df_illumina$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=recall_PVR),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#7BA151FF", "#B8DE29FF")) +
  theme(text = element_text(size=20)) +
  ylim(0, 1) +
  ylab("Pan-variants Recall") +
  xlab("Number of Samples")

dev.off()



png(file="recall_per_nb_of_samples.illumina.recall_AvgAR.png", width=700, height=400)
ggplot(df_illumina, aes(x=NUMBER_OF_SAMPLES, y=recall_AvgAR, fill=tool)) +
  geom_boxplot(data = df_illumina[df_illumina$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool)),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_illumina[df_illumina$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=recall_AvgAR),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#7BA151FF", "#B8DE29FF")) +
  theme(text = element_text(size=20)) +
  ylim(0, 1) +
  ylab("Average Allelic Recall") +
  xlab("Number of Samples")


dev.off()



png(file="recall_per_nb_of_samples.nanopore.nb_of_found_panvars.png", width=700, height=400)

ggplot(df_nanopore, aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar, fill=tool)) +
  geom_boxplot(data = df_nanopore[df_nanopore$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool)),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_nanopore[df_nanopore$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#440154FF", "#453781CF")) +
  theme(text = element_text(size=20)) +
  ylim(0, 80000) +
  ylab("Number of Pan-variants found") +
  xlab("Number of Samples")

dev.off()



png(file="recall_per_nb_of_samples.nanopore.recall_PVR.png", width=700, height=400)

ggplot(df_nanopore, aes(x=NUMBER_OF_SAMPLES, y=recall_PVR, fill=tool)) +
  geom_boxplot(data = df_nanopore[df_nanopore$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool)),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_nanopore[df_nanopore$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=recall_PVR),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#440154FF", "#453781CF")) +
  theme(text = element_text(size=20)) +
  ylim(0, 1) +
  ylab("Pan-variants Recall") +
  xlab("Number of Samples")

dev.off()



png(file="recall_per_nb_of_samples.nanopore.recall_AvgAR.png", width=700, height=400)
ggplot(df_nanopore, aes(x=NUMBER_OF_SAMPLES, y=recall_AvgAR, fill=tool)) +
  geom_boxplot(data = df_nanopore[df_nanopore$tool != "pandora with denovo", ],
               aes(group=interaction(NUMBER_OF_SAMPLES, tool)),
               outlier.colour="black", outlier.shape=8, position=position_dodge(1)) +
  geom_line(data = df_nanopore[df_nanopore$tool == "pandora with denovo", ],
            aes(x=NUMBER_OF_SAMPLES, y=recall_AvgAR),
            inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed") +
  scale_fill_manual(values=c("#440154FF", "#453781CF")) +
  theme(text = element_text(size=20)) +
  ylim(0, 1) +
  ylab("Average Allelic Recall") +
  xlab("Number of Samples")


dev.off()



library(png)
library(grid)
library(gridExtra)

png(file="Figure7.png", width=1400, height=1200)

absolute_counts_illumina <- grid::rasterGrob(readPNG("recall_per_nb_of_samples.illumina.nb_of_found_panvars.png"))
pvr_illumina <- grid::rasterGrob(readPNG("recall_per_nb_of_samples.illumina.recall_PVR.png"))
avgar_illumina <- grid::rasterGrob(readPNG("recall_per_nb_of_samples.illumina.recall_AvgAR.png"))
absolute_counts_nanopore <- grid::rasterGrob(readPNG("recall_per_nb_of_samples.nanopore.nb_of_found_panvars.png"))
pvr_nanopore <- grid::rasterGrob(readPNG("recall_per_nb_of_samples.nanopore.recall_PVR.png"))
avgar_nanopore <- grid::rasterGrob(readPNG("recall_per_nb_of_samples.nanopore.recall_AvgAR.png"))


gridExtra::grid.arrange(
  arrangeGrob(absolute_counts_illumina, top = textGrob("A",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(absolute_counts_nanopore, top = textGrob("B",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(pvr_illumina, top = textGrob("C",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(pvr_nanopore, top = textGrob("D",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(avgar_illumina, top = textGrob("E",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(avgar_nanopore, top = textGrob("F",  x = 0.05, gp=gpar(fontsize=30))),
  ncol=2
  )

dev.off()