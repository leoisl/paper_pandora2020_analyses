library(png)
library(grid)
library(gridExtra)
library(ggplot2)

real_example_figure <- grid::rasterGrob(readPNG("real_example/real_example.proportion.png"))
single_ref_problem_figure <- grid::rasterGrob(readPNG("single_ref_problem/single_ref_problem.png"))

gene_frequency_distribution_figure <- gridExtra::grid.arrange(
  arrangeGrob(real_example_figure, top = textGrob("a",  x = 0.05, gp=gpar(fontsize=20))),
  arrangeGrob(single_ref_problem_figure, top = textGrob("b",  x = 0.05, gp=gpar(fontsize=20))),
  nrow=1
)


ggsave(gene_frequency_distribution_figure, file="gene_frequency_distribution.png", width=14, height=5, dpi=300)