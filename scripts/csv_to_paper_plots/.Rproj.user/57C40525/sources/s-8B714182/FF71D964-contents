library(ggplot2)
library(data.table)
library(ggthemr)

# Read in data 
four_way_df <- fread("ROC_data_old_and_new_basecall.R_data.csv", header=TRUE, sep=",")

ggthemr('fresh')

four_way_plot = ggplot(data=four_way_df, aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                                             group=tool, linetype=methylation_aware, colour=local_assembly)) +
  geom_line() + 
  scale_x_continuous("Error rate", limits = c(0.0035,0.007), breaks= seq(0.0035,0.007,by=0.0005)) +
  scale_y_continuous("Average allelic recall", limits = c(0.75, 0.91), breaks= seq(0.75,0.91,by=0.05)) +
  theme(legend.title = element_text(size = 8), 
        legend.text = element_text(size = 8)) +
  theme(legend.position = "bottom")

four_way_plot$labels$linetype = "Methylation aware"
four_way_plot$labels$colour = expression(paste(italic("De novo"), " discovery"))

ggsave(four_way_plot, file="ROC_data_old_and_new_basecall.png", width=6.5, height=5, dpi=300)

