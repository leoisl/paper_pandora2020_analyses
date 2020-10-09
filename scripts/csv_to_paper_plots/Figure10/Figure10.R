library(tidyverse)
library(reshape2)
library(plyr)

###############################################################################################
# args
args <- commandArgs(trailingOnly=TRUE)
technology <- args[1]
###############################################################################################

## Load the data
csv_file <- paste("gene_sample_ref_ED_nbsamples.", technology, ".csv", sep="")
genes<-read_csv(csv_file)
genesclean<- genes %>% select(-edit_distance_labels)
pandora_ref <- paste("pandora_", technology, "_100x_withdenovo", sep="")

###########################################################################
# OK, let's start by plotting the frequency distribution of genes
p<- filter(genesclean, ref==pandora_ref)
r1<- filter(genesclean,ref=="NZ_CP018109.1")
r2<- filter(genesclean,ref=="CP010230.1")
r3<- filter(genesclean,ref=="NZ_LT632320.1")
r4<- filter(genesclean,ref=="CU928163.2")
r5<- filter(genesclean,ref=="NZ_CP009859.1")

g<- genesclean %>% select(-sample) %>% select(-edit_distance) %>% select(-ref) %>% unique()

better_count_good<-function(dat, edit,mini, maxi)
{
  return( nrow(filter(dat, edit_distance<=edit, nb_of_samples<=maxi, nb_of_samples>=mini)))
}

png(file=paste("Figure10.freq_dist_genes.", technology, ".png", sep=""), width=700, height=500)
hist(g$nb_of_samples)
dev.off()
###########################################################################



###########################################################################
# Now we ask ourselves, how many (gene,sample) pairs are there where pandora has achieved edit distance zero, across the frequency spectrum
results <- tibble(xx = 1:20,
                  pan_ref=rep(0,20),
                  ref1=rep(0,20),
                  ref2=rep(0,20),
                  ref3=rep(0,20),
                  ref4=rep(0,20),
                  ref5=rep(0,20))
results1perc <- tibble(xx = 1:20,
                       pan_ref=rep(0,20),
                       ref1=rep(0,20),
                       ref2=rep(0,20),
                       ref3=rep(0,20),
                       ref4=rep(0,20),
                       ref5=rep(0,20))
for (i in 1:20)
{
  results$pan_ref[i] = better_count_good(p,0,i,i)
  results$ref1[i] = better_count_good(r1,0,i,i)
  results$ref2[i] = better_count_good(r2,0,i,i)
  results$ref3[i] = better_count_good(r3,0,i,i)
  results$ref4[i] = better_count_good(r4,0,i,i)
  results$ref5[i] = better_count_good(r5,0,i,i)
  
  results1perc$pan_ref[i] = better_count_good(p,0.01,i,i)
  results1perc$ref1[i] = better_count_good(r1,0.01,i,i)
  results1perc$ref2[i] = better_count_good(r2,0.01,i,i)
  results1perc$ref3[i] = better_count_good(r3,0.01,i,i)
  results1perc$ref4[i] = better_count_good(r4,0.01,i,i)
  results1perc$ref5[i] = better_count_good(r5,0.01,i,i)
}


# Melt data for plotting with reshape2::melt
new_res = melt(results, id.vars="xx", measure.vars= c("pan_ref","ref1", "ref2", "ref3", "ref4", "ref5"))
new_res_1perc = melt(results1perc, id.vars="xx", measure.vars= c("pan_ref","ref1", "ref2", "ref3", "ref4", "ref5"))


png(file=paste("Figure10.sample_gene_pairs_with_edit_distance_zero.", technology, ".png", sep=""), width=700, height=500)
#Plot data and set colours = variable col
ggplot(data=filter(new_res,xx<10)) +
  geom_line(mapping=aes(x=xx, y=value, colour = variable)) +
  scale_x_discrete(limits=factor(1:9)) + 
  ylab("Num times a gene in a sample is edit dist 0 from the reference") +
  xlab("gene count in population") + 
  ggtitle("How many (sample,gene) pairs are edit distance zero from refs") 
dev.off()


# this was commented out, kept it here
#ggplot(data=filter(results,xx<10))+ylab("Num times a gene in a sample is edit dist 0 from the reference")+xlab("gene count in population")+geom_line(mapping=aes(x=xx, y=pan_ref))  + scale_x_continuous(breaks = 1:20) +ggtitle("How many (sample,gene) pairs are edit distance zero from refs")+geom_line(mapping=aes(x=xx, y=ref1, color="red"))+geom_line(mapping=aes(x=xx, y=ref2, color="blue"))+geom_line(mapping=aes(x=xx, y=ref3, color="green"))+geom_line(mapping=aes(x=xx, y=ref4, color="brown"))


png(file=paste("Figure10.sample_gene_pairs_within_1perc_distance_gene_count_up_to_10.", technology, ".png", sep=""), width=700, height=500)
ggplot(data=filter(new_res_1perc,xx<10)) +
  geom_line(mapping=aes(x=xx, y=value, colour = variable)) +
  scale_x_discrete(limits=factor(1:9)) + 
  ylab("Num times a gene in a sample is edit dist <=0.01  from the reference") +
  xlab("gene count in population") + 
  ggtitle("How many (sample,gene) pairs are within 1% of refs") 
dev.off()


# this was commented out, kept it here
#ggplot(data=filter(results1perc,xx<10))+ylab("Num times a gene in a sample is edit dist <0.01 from ref")+xlab("gene count in population")+geom_line(mapping=aes(x=xx, y=pan_ref))  + scale_x_continuous(breaks = 1:20) +ggtitle("How many (sample,gene) pairs are within 1% edit distance  from refs")+geom_line(mapping=aes(x=xx, y=ref1, color="red"))+geom_line(mapping=aes(x=xx, y=ref2, color="blue"))+geom_line(mapping=aes(x=xx, y=ref3, color="green"))+geom_line(mapping=aes(x=xx, y=ref4, color="brown"))


png(file=paste("Figure10.sample_gene_pairs_within_1perc_distance_gene_count_up_to_20.", technology, ".png", sep=""), width=1100, height=500)
ggplot(data=filter(new_res_1perc,xx<20)) +
  geom_line(mapping=aes(x=xx, y=value, colour = variable)) +
  scale_x_discrete(limits=factor(1:19)) + 
  ylab("Num times a gene in a sample is edit dist <=0.01  from the reference") +
  xlab("gene count in population") + 
  ggtitle("How many (sample,gene) pairs are within 1% of refs") 
dev.off()




##################################################################################################################################
# Lastly, let's ask - how often is pandora's reference at least as close as the best other reference?
mini<-filter(genesclean, ref != "NZ_CP018109.1", ref !="CP010230.1", ref!="NZ_LT632320.1", sample=="Escherichia_coli_MSB1_4E")

## check one gene/sample combination
at_least_as_good<-function(gid, sam)
{
  # get all the data for one gene/sample combination
  info<- filter(mini, gene_name==gid, sample==sam)
  
  others<-filter(info, ref != pandora_ref)
  
  if (nrow(others)>0)
  {
    ## if vcfref is closest (or as close as closest)
    if ( (info %>% filter(ref == pandora_ref) %>% pull(edit_distance)) <= ( others %>% pull(edit_distance) %>% min() ) )
    {
      return(1)
    }
    else 
    {
      return(0)
    }
  }
  else
  { 
    return(-1)
  }
}



gs<-genesclean %>% select(-ref) %>% select(-edit_distance) %>% select(-nb_of_samples) %>% unique()

#group by (sample, gene) pairs, and  insist at least one non-pandora reference contains it
by_gs <-  group_by(genesclean, gene_name, sample) %>% filter(n()>1)
pandora_closest <- by_gs %>% filter(edit_distance==min(edit_distance)) %>% summarise(pan_wins=max(ref==pandora_ref))

r1_closest <- by_gs %>% filter(edit_distance==min(edit_distance)) %>% summarise(r1_wins=max(ref=="NZ_CP018109.1"))
r2_closest <- by_gs %>% filter(edit_distance==min(edit_distance)) %>% summarise(r2_wins=max(ref=="CP010230.1"))
r3_closest <- by_gs %>% filter(edit_distance==min(edit_distance)) %>% summarise(r3_wins=max(ref=="NZ_LT632320.1"))
r4_closest <- by_gs %>% filter(edit_distance==min(edit_distance)) %>% summarise(r4_wins=max(ref=="CU928163.2"))
r5_closest <- by_gs %>% filter(edit_distance==min(edit_distance)) %>% summarise(r5_wins=max(ref=="NZ_CP009859.1"))                                               

# TODO: we might want to plot/print this?
sum(pandora_closest$pan_wins)

# That number above is the number of gene/sample combinations where the pandora vcf_ref is the closest reference (possible equal closest). Now look at the other 5:

# TODO: we might want to plot/print this?  
sum(r1_closest$r1_wins)
sum(r2_closest$r2_wins)
sum(r3_closest$r3_wins)
sum(r4_closest$r4_wins)
sum(r5_closest$r5_wins)

# So two of the other references are the closest more often.
# Lastly, how often was pandora in fact the only reference

by_gs_onlyp <-  group_by(genesclean, gene_name, sample) %>% filter(n()==1)

png(file=paste("Figure10.how_ofter_pandora_is_only_ref.", technology, ".png", sep=""), width=700, height=500)
hist(by_gs_onlyp$edit_distance)
dev.off()
