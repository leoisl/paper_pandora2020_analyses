#=====================
# setup
#=====================
library(data.table)
library(ggplot2)
library(pheatmap)
library(reshape)


#=====================
# Read in data
#=====================
count_df_dat <- fread("two_SNP_heatmap_count_df.csv", header=TRUE,
                      sep=",")

count_df<-as.data.frame(pivot_wider(count_df_dat, names_from = FIRST_SAMPLE, 
                      values_from = count))

#=====================
# Set ordering for plot
#=====================

samples_ordered_by_clade =c("MSB1_9D","H131800734","MINF_8D","MSB1_1A","MSB1_8G","MSB1_4E",
                            "063_STEC","CFT073","MSB2_1A","MINF_1D","MSB1_7C","MINF_7C","MSB1_6C",
                            "ST38","MSB1_7A","MSB1_3B","MSB1_4I","MINF_1A","MINF_9A","MSB1_8B")

#===============================================================
# Set order, convert  df > mat > df to get upper matrix
#===============================================================
rownames(count_df)<-count_df$SECOND_SAMPLE
count_df<-count_df[,2:ncol(count_df)]

sample_index_col = as.vector(match(samples_ordered_by_clade,
                            colnames(count_df)))

sample_index_row = as.vector(match(samples_ordered_by_clade,
                                   rownames(count_df)))


count_df = count_df[sample_index_row,sample_index_col] 


countmat <-data.matrix(count_df)


countmat[lower.tri(countmat)] = NA


#=====================
# Melt and plot data
#=====================
count_df_plot<-as.data.frame(countmat)
count_df_plot$SECOND_SAMPLE<-rownames(count_df)


count_melt <-na.omit(melt(count_df_plot, 'SECOND_SAMPLE', 
                  variable_name='FIRST_SAMPLE'))

count_melt$FIRST_SAMPLE <- factor(count_melt$FIRST_SAMPLE, 
                          levels=rev(samples_ordered_by_clade))

count_melt$SECOND_SAMPLE <- factor(count_melt$SECOND_SAMPLE, 
                                  levels=samples_ordered_by_clade)

# Custom label for legend
custom_label= expression(paste("log"[2]*"(counts + 1)"))


# Set up colour ramps based on order of plotting for each axis
sample_to_colour_forward = c(rep("#FF00FF", 5), rep("#00ceffff", 5),
                     rep("#008000ff",6), rep("#FF0000", 4))
 
sample_to_colour_reverse = c( 
                              rep("#FF0000", 4), rep("#008000ff",6),
                             rep("#00ceffff", 5),rep("#FF00FF", 5))



#=====================
# heatmap
#=====================
heatmap_fig = ggplot(count_melt, aes(FIRST_SAMPLE, SECOND_SAMPLE)) +
  theme_bw() +
  xlab('') +
  ylab('') +
  geom_tile(aes(fill= log(value+1)), color='gray') +
  scale_fill_gradientn(colours = pal)  + 
  theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.line = element_line(colour = "grey50")) +
  theme(axis.text.x = element_text(angle = 45, hjust =1)) + 
  guides(fill=guide_legend(title=custom_label)) +
  theme(legend.title = element_text(size=10)) +
  theme(legend.title.align = 0.5) +
  theme(axis.text.x = element_text(colour = sample_to_colour_reverse)) +
  theme(axis.text.y = element_text(colour = sample_to_colour_forward))

ggsave(heatmap_fig, file="Figure9.png", width=7, height=5, dpi=300)
