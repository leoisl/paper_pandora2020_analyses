library("ggplot2")

setwd("~/Desktop")


# import data
# this one has the data for the line (Pandora with denovo)
panden <- read.csv("pandora_withdenovo.tsv", sep='\t', header=TRUE)
panden$NUMBER_OF_SAMPLES <- as.factor(panden$NUMBER_OF_SAMPLES)

# this one has all of the snippy/samtools results
both <- read.csv("snippy-samtools.tsv", sep='\t', header=TRUE)
both$NUMBER_OF_SAMPLES <- as.factor(both$NUMBER_OF_SAMPLES)

# plot: 
p <- ggplot(both, aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar, fill=type)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8, position=position_dodge(1))
q <- p + geom_line(data=panden, aes(x=NUMBER_OF_SAMPLES, y=nb_of_found_PanVar), inherit.aes = FALSE, size=0.5, group = 1, linetype = "dashed")
q+scale_fill_manual(values=c("#999999", "#E69F00"))
