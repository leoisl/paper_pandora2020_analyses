#=====================
# setup
#=====================
library(assertr)
library(ggplot2)
library(data.table)
library(ggthemr)
library(tidyverse)
library(ggnewscale)
library(gridExtra)

#=====================
# Read in data
#=====================
args <- commandArgs(trailingOnly=TRUE)
illumina_20_way_df <- fread(args[1], header=TRUE, sep=",")
nanopore_20_way_df <- fread(args[2],header=TRUE, sep=",")
precision_per_sample_illumina_df <- read.csv(args[3], header=TRUE, sep=",")
precision_per_sample_nanopore_df <- read.csv(args[4], header=TRUE, sep=",")

tool_palette <-fread("tool_palette.csv",header=TRUE, sep=",")

ggthemr('fresh')

#Ensure that the unique values to be attributed to `colour` are present in `tool_palette$tool` 
unique(illumina_20_way_df$tool) %in% tool_palette$tool 


illumina_colour_palette = tool_palette %>% 
  filter(tool %in% unique(illumina_20_way_df$tool)) %>% 
  pull(palette)
                            
#=====================
# Illumina 20 way plot
#=====================
illumina_20_way_plot <-ggplot(data=illumina_20_way_df, 
                              aes(x=error_rate, 
                                  y=recalls_wrt_variants_found_wrt_alleles,
                                  group=tool_long_name, 
                                  colour=tool)) +
  geom_line() +
  scale_x_continuous("Error rate", 
                     limits = c(0, 0.02), 
                     breaks= seq(0, 0.02, by=0.002)) +
  scale_y_continuous("Average allelic recall", 
                     limits = c(0.65, 0.9), 
                     breaks= seq(0.65, 0.9, by=0.05)) +
  scale_color_manual(values= c(illumina_colour_palette)) +
  theme(legend.position = "None") + 
  labs(tag="a")

#=====================
# Nanopore 20 way plot
#=====================
unique(nanopore_20_way_df$tool) %in% tool_palette$tool 

nanopore_colour_palette = tool_palette %>% 
  filter(tool %in% unique(nanopore_20_way_df$tool)) %>% 
  pull(palette)

nanopore_20_way_plot <-ggplot(data=nanopore_20_way_df, 
                              aes(x=error_rate, 
                                  y=recalls_wrt_variants_found_wrt_alleles,
                                  group=tool_long_name, 
                                  colour=tool)) +
  geom_line() +
  scale_x_continuous("Error rate", 
                     limits = c(0, 0.2), 
                     breaks= seq(0, 0.2, by=0.02)) +
  scale_y_continuous("Average allelic recall", 
                     limits = c(0.65, 0.9), 
                     breaks= seq(0.65, 0.9, by=0.05)) +
  scale_color_manual(values= c(nanopore_colour_palette)) +
  theme(legend.position = "None") + 
  labs(tag="b")

#=========================
# Illumina precision plot
#=========================
#pandora here is pandora with denovo
unique(precision_per_sample_illumina_df$tool) %in% tool_palette$tool 
precision_per_sample_illumina_df$tool <-as.character(precision_per_sample_illumina_df$tool)
precision_per_sample_illumina_df <-precision_per_sample_illumina_df %>% 
  mutate(tool = replace(tool, tool == 'pandora', 'pandora with denovo'))

illumina_precision_colour_palette = tool_palette %>% 
  filter(tool %in% unique(precision_per_sample_illumina_df$tool)) %>%
  pull(palette)

illumina_precision_plot = ggplot(precision_per_sample_illumina_df, 
       aes(x = sample, y = precision)) + 
  geom_boxplot(data = precision_per_sample_illumina_df[precision_per_sample_illumina_df$tool != "pandora with denovo", ],
               aes(group = interaction(sample, tool), 
                    fill=tool, colour=tool)) +
  scale_fill_manual(values = c("white", "white")) +
  scale_colour_manual(values = c(illumina_precision_colour_palette[2:3]))  +
  new_scale_color() +
  new_scale_fill() +
  geom_line(data = precision_per_sample_illumina_df[precision_per_sample_illumina_df$tool == "pandora with denovo", ], 
            aes(group=tool, colour=tool)) +
  scale_fill_manual(values = "white") +
  scale_colour_manual(values = c(illumina_precision_colour_palette[1])) +
  theme(axis.text.x = element_text(angle = 45, hjust =1)) +
  ylab("Precision") +
  xlab("Sample") +
  theme(legend.position = "None") + 
  labs(tag="c")



#=========================
# nanopore precision plot
#=========================
#pandora here is pandora with denovo
unique(precision_per_sample_nanopore_df$tool) %in% tool_palette$tool 
precision_per_sample_nanopore_df$tool <-as.character(precision_per_sample_nanopore_df$tool)
precision_per_sample_nanopore_df <-precision_per_sample_nanopore_df %>% 
  mutate(tool = replace(tool, tool == 'pandora', 'pandora with denovo'))

nanopore_precision_colour_palette = tool_palette %>% 
  filter(tool %in% unique(precision_per_sample_nanopore_df$tool)) %>%
  pull(palette)

nanopore_precision_plot = ggplot(precision_per_sample_nanopore_df, 
                                 aes(x = sample, y = precision)) + 
  geom_boxplot(data = precision_per_sample_nanopore_df[precision_per_sample_nanopore_df$tool != "pandora with denovo", ],
               aes(group = interaction(sample, tool), 
                   fill=tool, colour=tool)) +
  scale_fill_manual(values = c("white", "white")) +
  scale_colour_manual(values = c(nanopore_precision_colour_palette[1:2]))  +
  new_scale_color() +
  new_scale_fill() +
  geom_line(data = precision_per_sample_nanopore_df[precision_per_sample_nanopore_df$tool == "pandora with denovo", ], 
            aes(group=tool, colour=tool)) +
  scale_fill_manual(values = "white") +
  scale_colour_manual(values = c(nanopore_precision_colour_palette[3])) +
  theme(axis.text.x = element_text(angle = 45, hjust =1)) +
  ylab("Precision") +
  xlab("Sample") +
  theme(legend.position = "None") + 
  labs(tag="d")


#=================
# Custom legend
#=================
custom_legend_df <-rbind(illumina_20_way_df, nanopore_20_way_df)

custom_legend_plot <-ggplot(data=custom_legend_df, 
                            aes(x=error_rate, y=recalls_wrt_variants_found_wrt_alleles,
                                group=tool_long_name,
                                colour=tool)) + 
  geom_point() +
  scale_x_continuous("Error rate",
                     limits = c(0, 0.2),
                     breaks= seq(0, 0.2, by=0.02)) +
  scale_y_continuous("Average allelic recall", 
                     limits = c(0.65, 0.9),
                     breaks= seq(0.65, 0.9, by=0.05)) +
  scale_color_manual(values= c(tool_palette$palette),
                     labels= c("medaka", "nanopolish", "pandora", 
                               expression(paste("pandora ", italic("de novo"))), 
                               "samtools", "snippy")) +
  theme(legend.position = "bottom", legend.title = element_blank())+ 
  guides(colour = guide_legend(nrow = 1,reverse = TRUE)) +
  labs("")
  


g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

custom_legend<-g_legend(custom_legend_plot)

top_half_fig = grid.arrange(arrangeGrob(illumina_20_way_plot, 
                                        nanopore_20_way_plot,
                                        nrow=1),
                            custom_legend, nrow=2, heights=c(10,1))
bottom_half_fig = grid.arrange(arrangeGrob(illumina_precision_plot, 
                                           nanopore_precision_plot,
                                           nrow=1))
final_plot = grid.arrange(top_half_fig, bottom_half_fig)

ggsave(final_plot, file=args[5], width=15, height=10, dpi=300)
