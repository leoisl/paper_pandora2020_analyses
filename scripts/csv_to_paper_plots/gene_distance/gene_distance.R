library(tidyverse)
library(reshape2)
library(ggthemr)

#############################
# Load in csv
#############################
genes<-read_csv("gene_sample_ref_ED_nbsamples.nanopore.csv")

#############################
# Parse out pandora data for 1%
#############################
pandora_dat_0.01<-genes %>%
  filter(edit_distance <= 0.01) %>%
  dplyr::filter(ref =="pandora_nanopore_100x_withdenovo") %>%
  dplyr::select(ref, nb_of_samples) %>%
  group_by(ref) %>% 
  dplyr::count(nb_of_samples)

#############################
# Set up axis labels
#############################
y_axis_labs = c(expression(paste("10"^"1")),
                expression(paste("10"^"2")),
                expression(paste("10"^"3")),
                expression(paste("10"^"4")),
                expression(paste("10"^"5")))
                
pandora_lab = expression(paste(italic("pandora")))

ggthemr('fresh')
#############################
# Plot 1% data
#############################
genes_boxplot_0.01 = genes %>%
  filter(edit_distance <= 0.01) %>%
  dplyr::filter(!ref =="pandora_nanopore_100x_withdenovo") %>%
  dplyr::select(ref, nb_of_samples) %>%
  group_by(ref) %>% 
  dplyr::count(nb_of_samples) %>%
  ggplot(.,aes(x = nb_of_samples, 
               y = log(n+1,10),
               group=nb_of_samples)) +
  geom_boxplot(outlier.shape = NA, 
               alpha=0) + 
  geom_point(shape=16, 
             colour = "grey10", 
             size=0.75) +
  geom_line(data= pandora_dat_0.01, 
            aes(x=pandora_dat_0.01$nb_of_samples,
                y = log(pandora_dat_0.01$n+1, 10), 
                group=1)) +
  geom_point(data= pandora_dat_0.01, 
             aes(x=pandora_dat_0.01$nb_of_samples,
                 y = log(pandora_dat_0.01$n+1, 10), 
                 group=1)) +
  scale_x_continuous("Number of samples", 
                     limits = c(0,21), 
                     breaks= seq(1,20,by=1), 
                     expand=c(0,0)) +
  scale_y_continuous("Number of genes (edit distance <=1%)", 
                     limits = c(1, 5), 
                     breaks= seq(1,5,by=1),
                     labels=y_axis_labs) +
  annotate("text",
           label=pandora_lab, 
           x=18.65,
           y=4.1,
           size=3.5,
           colour = "#65ADC2")



#############################
# Parse out pandora data for 0%
#############################
pandora_dat_0.00<-genes %>%
  filter(edit_distance == 0.00) %>%
  dplyr::filter(ref =="pandora_nanopore_100x_withdenovo") %>%
  dplyr::select(ref, nb_of_samples) %>%
  group_by(ref) %>% 
  dplyr::count(nb_of_samples)


#############################
# Plot 0% data
#############################
genes_boxplot_0.00 = genes %>%
  filter(edit_distance == 0.00) %>%
  dplyr::filter(!ref =="pandora_nanopore_100x_withdenovo") %>%
  dplyr::select(ref, nb_of_samples) %>%
  group_by(ref) %>% 
  dplyr::count(nb_of_samples) %>%
  ggplot(.,aes(x = nb_of_samples, 
               y = log(n+1,10),
               group=nb_of_samples)) +
  geom_boxplot(outlier.shape = NA, 
               alpha=0) + 
  geom_point(shape=16, 
             colour = "grey10", 
             size=0.75) +
  geom_line(data= pandora_dat_0.00, 
            aes(x=pandora_dat_0.00$nb_of_samples,
                y = log(pandora_dat_0.00$n+1, 10), 
                group=1)) +
  geom_point(data= pandora_dat_0.00, 
             aes(x=pandora_dat_0.00$nb_of_samples,
                 y = log(pandora_dat_0.00$n+1, 10), 
                 group=1)) +
  scale_x_continuous("Number of samples", 
                     limits = c(0,21), 
                     breaks= seq(1,20,by=1), 
                     expand=c(0,0)) +
  scale_y_continuous("Number of genes (edit distance = 0%)", 
                     limits = c(0.3, 5), 
                     breaks= seq(1,5,by=1),
                     labels=y_axis_labs) +
  annotate("text",
           label=pandora_lab, 
           x=18.75,
           y=3.7,
           size=3.5,
           colour = "#65ADC2")


#############################
# Save plots
#############################
ggsave(genes_boxplot_0.01, 
       file="loci_ref_sample_approximation_ed_1.png", 
       width=6.3, 
       height=4.2, 
       dpi=300)

ggsave(genes_boxplot_0.00, 
       file="loci_ref_sample_approximation_ed_0.png", 
       width=6.3, 
       height=4.2, 
       dpi=300)



