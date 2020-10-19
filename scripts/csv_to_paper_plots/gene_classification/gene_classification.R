library(png)
library(grid)
library(gridExtra)

png(file="gene_classification.png", width=1200, height=800)

gene_classification_illumina <- grid::rasterGrob(readPNG("gene_classification_by_gene_length.illumina.png"))
gene_classification_illumina_normalised <- grid::rasterGrob(readPNG("gene_classification_by_gene_length_normalised.illumina.png"))
gene_classification_nanopore <- grid::rasterGrob(readPNG("gene_classification_by_gene_length.nanopore.png"))
gene_classification_nanopore_normalised <- grid::rasterGrob(readPNG("gene_classification_by_gene_length_normalised.nanopore.png"))


gridExtra::grid.arrange(
  arrangeGrob(gene_classification_illumina_normalised, top = textGrob("A",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(gene_classification_illumina, top = textGrob("B",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(gene_classification_nanopore_normalised, top = textGrob("C",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(gene_classification_nanopore, top = textGrob("D",  x = 0.05, gp=gpar(fontsize=30))),
  ncol=2
  )

dev.off()
