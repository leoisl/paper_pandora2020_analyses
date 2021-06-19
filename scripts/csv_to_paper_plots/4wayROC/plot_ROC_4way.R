library(ggplot2)
library(data.table)
library(ggthemr)

# Read in data 
four_way_df <- fread("ROC_data_old_and_new_basecall.R_data.csv", header=TRUE, sep=",")

ggthemr('fresh')

# Set linetype legend colour
update_geom_defaults("line",   list(colour = "grey"))

custom_label= expression(paste("mosaic + ", italic("de novo")))
four_way_plot = ggplot(data=four_way_df, aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                                             group=tool, colour = local_assembly)) +
  geom_line(aes(linetype=four_way_df$methylation_aware)) + 
  scale_x_continuous("Error rate", limits = c(0.0,0.006), breaks= seq(0.0,0.006,by=0.001)) +
  scale_y_continuous("Average allelic recall", limits = c(0.75, 0.91), breaks= seq(0.75,0.91,by=0.05)) +
  theme(legend.title = element_text(size = 8), 
        legend.text = element_text(size = 8)) +
  theme(legend.position = "bottom") + 
  scale_colour_discrete(name  ="", 
                       breaks=c("no", "yes"),
                       labels=c("mosaic", custom_label)) +
  scale_linetype_discrete(name= "",
                        breaks=c("no", "yes"),
                          labels=c("normal", "methylation aware")) 
  

ggsave(four_way_plot, file="ROC_data_old_and_new_basecall.png", width=6.5, height=5, dpi=300)

