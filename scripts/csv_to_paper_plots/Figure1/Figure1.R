library(png)
library(grid)
library(gridExtra)
library(ggplot2)

Figure1a <- grid::rasterGrob(readPNG("Figure1a/Figure1a.proportion.png"))
Figure1b <- grid::rasterGrob(readPNG("Figure1b/Figure1b.png"))

Figure1 <- gridExtra::grid.arrange(
  arrangeGrob(Figure1a, top = textGrob("A",  x = 0.05, gp=gpar(fontsize=20))),
  arrangeGrob(Figure1b, top = textGrob("B",  x = 0.05, gp=gpar(fontsize=20))),
  nrow=1
)


ggsave(Figure1, file="Figure1.png", width=14, height=5, dpi=300)