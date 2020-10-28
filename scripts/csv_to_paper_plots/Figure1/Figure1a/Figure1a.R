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


data <- read.csv("roary_output/all_count.txt", sep='\t', header=TRUE)

count_plot <- ggplot(data, aes(x=count, fill=species)) + geom_bar(position="dodge") +
  scale_x_discrete(limits=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")) + 
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())

ggsave(count_plot, file="Figure1a.count.png", width=7, height=5, dpi=300)


data <- read.csv("roary_output/gene_props_all.tsv", sep='\t', header=TRUE)

proportion_plot <- ggplot(data, aes(x=genomes, y=prop, group=species)) + geom_line(aes(linetype=species, color=species)) +
  geom_point(aes(color=species)) +
  scale_x_discrete(limits=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")) +
  theme(axis.title.x = element_blank(), axis.title.y = element_blank())


ggsave(proportion_plot, file="Figure1a.proportion.png", width=7, height=5, dpi=300)

