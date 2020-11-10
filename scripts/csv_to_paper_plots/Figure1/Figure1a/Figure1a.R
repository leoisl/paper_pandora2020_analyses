#Pandora: show that rare gene/core gene phenomenon same across several species
#
#-> pick 10 (mainly NCTC strains)
#E. coli - done
#Pseudomonas - done
#salmonella - done
#Strep pneumo - done
#kleb pneumo - done
#staph aureus - done
#
#-> download refseq annotation (gff, fna)
#-> cat gff and fna to make gff3
#-> had to change "###" before fasta sequence to "##FASTA" for it to work
#-> change to strain names
#-> separate into species folders
#-> run Roary (v3.7.0):
#
#```
#bsub.py 3 roary_ecoli roary -f ./roary-ecoli -e -v -n -cd 1 -z ecoli/*
#bsub.py 3 roary_kleb roary -f ./roary-kleb -e -v -n -cd 1 -z kleb/*
#bsub.py 3 roary_pseudo roary -f ./roary-pseudo -e -v -n -cd 1 -z pseudo/*
#bsub.py 3 roary_sal roary -f ./roary-sal -e -v -n -cd 1 -z sal/*
#bsub.py 3 roary_staph roary -f ./roary-staph -e -v -n -cd 1 -z staph/*
#bsub.py 3 roary_strep roary -f ./roary-strep -e -v -n -cd 1 -z strep/*
#```
#
#*Plot in R:*

library("ggplot2")
library(ggthemr)

ggthemr('fresh')
# Set linetype legend colour
update_geom_defaults("line",   list(colour = "grey"))

data <- read.csv("roary_output/all_count.txt", sep='\t', header=TRUE)

count_plot <- ggplot(data, aes(x=count, fill=species)) + geom_bar(position="dodge") +
  scale_x_discrete(limits=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")) + 
  scale_fill_discrete(
    "Species",
    labels = c(expression(italic("E. coli")),
               expression(italic("K. pneumoniae")),
               expression(italic("P. aeruginosa")),
               expression(italic("S. aureus")),
               expression(italic("S. enterica")),
               expression(italic("S. pneumoniae")))) +
  theme(
      axis.title.x = element_text(size=14),
      axis.title.y = element_text(size=14),
      axis.text.x = element_text(size=14),
      axis.text.y = element_text(size=14),
      legend.title = element_text(size=14),
      legend.text = element_text(size=14)) +
  ylab("Count of genes") +
  xlab("Number of genomes") +
  theme(legend.text.align = 0)


ggsave(count_plot, file="Figure1a.count.png", width=7, height=5, dpi=300)


data <- read.csv("roary_output/gene_props_all.tsv", sep='\t', header=TRUE)

proportion_plot <- ggplot(data, aes(x=genomes, y=prop, fill=species)) + geom_bar(stat='identity', position="dodge") +
  scale_x_discrete(limits=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")) +
  scale_y_continuous(breaks = c(0.1, 0.2, 0.3, 0.4, 0.5)) +
  scale_fill_discrete(
    "Species",
    labels = c(expression(italic("E. coli")),
               expression(italic("K. pneumoniae")),
               expression(italic("P. aeruginosa")),
               expression(italic("S. aureus")),
               expression(italic("S. enterica")),
               expression(italic("S. pneumoniae")))) +
  theme(
    axis.title.x = element_text(size=14),
    axis.title.y = element_text(size=14),
    axis.text.x = element_text(size=14),
    axis.text.y = element_text(size=14),
    legend.title = element_text(size=14),
    legend.text = element_text(size=14)) +
  ylab("Proportion of genes") +
  xlab("Number of genomes") +
  theme(legend.text.align = 0)


ggsave(proportion_plot, file="Figure1a.proportion.png", width=7, height=5, dpi=300)

