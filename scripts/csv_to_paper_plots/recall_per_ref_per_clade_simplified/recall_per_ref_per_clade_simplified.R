library(png)
library(grid)
library(gridExtra)

png(file="recall_per_ref_per_clade_simplified.png", width=1500, height=600)

recall_per_ref_per_clade_simplified_pandora_snippy_recall <- grid::rasterGrob(readPNG("recall_per_ref_per_clade_simplified_pandora_snippy_recall.png"))
recall_per_ref_per_clade_simplified_pandora_snippy_recall_2_snps <- grid::rasterGrob(readPNG("recall_per_ref_per_clade_simplified_pandora_snippy_recall_2_snps.png"))


gridExtra::grid.arrange(
  arrangeGrob(recall_per_ref_per_clade_simplified_pandora_snippy_recall, top = textGrob("a",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(recall_per_ref_per_clade_simplified_pandora_snippy_recall_2_snps, top = textGrob("b",  x = 0.05, gp=gpar(fontsize=30))),
  ncol=1,
  nrow=2
)

dev.off()
