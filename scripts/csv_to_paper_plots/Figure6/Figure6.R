library(png)
library(grid)
library(gridExtra)

png(file="Figure6.png", width=1400, height=900)

illumina_20_way <- grid::rasterGrob(readPNG("../20wayROC/ROC_data_20_way_illumina.R_data.png"))
nanopore_20_way <- grid::rasterGrob(readPNG("../20wayROC/ROC_data_20_way_nanopore.R_data.png"))
precision_per_sample_illumina <- grid::rasterGrob(readPNG("../precision_per_sample/precision_per_sample_illumina.png"))
precision_per_sample_nanopore <- grid::rasterGrob(readPNG("../precision_per_sample/precision_per_sample_nanopore.png"))


gridExtra::grid.arrange(
  arrangeGrob(illumina_20_way, top = textGrob("A",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(nanopore_20_way, top = textGrob("B",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(precision_per_sample_illumina, top = textGrob("C",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(precision_per_sample_nanopore, top = textGrob("D",  x = 0.05, gp=gpar(fontsize=30))),
  ncol=2,
  heights= c(500, 400),
  widths = c(700, 700)
  )

dev.off()
