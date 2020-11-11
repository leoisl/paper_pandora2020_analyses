library(png)
library(grid)
library(gridExtra)

png(file="Figure8.png", width=1500, height=600)

fig8a <- grid::rasterGrob(readPNG("Figura8A.png"))
fig8b <- grid::rasterGrob(readPNG("Figura8B.png"))


gridExtra::grid.arrange(
  arrangeGrob(fig8a, top = textGrob("a",  x = 0.05, gp=gpar(fontsize=30))),
  arrangeGrob(fig8b, top = textGrob("b",  x = 0.05, gp=gpar(fontsize=30))),
  ncol=1,
  nrow=2
)

dev.off()
