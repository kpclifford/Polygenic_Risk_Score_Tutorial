
library(data.table)
library(tidyverse)


## Import the target .bim files

#set the working directory from which the files will be read from
setwd("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/targetBim")

#create a list of the files from your target directory
data_dir <- "/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/targetBim"
file_list <- list.files(path=data_dir,full.names = F, pattern="*\\.bim")

#initiate a blank data frame, each iteration of the loop will append the data from the given file to this variable
dataset <- data.frame()

#had to specify columns to get rid of the total column
for (i in 1:length(file_list)){
  temp_data <- fread(file_list[i], stringsAsFactors = F) #read in files using the fread function from the data.table package
  dataset <- rbindlist(list(dataset, temp_data), use.names = T) #for each iteration, bind the new data to the building dataset
}


nrows(dataset) #5,462,632 rows
head(dataset)
##################################################################

# Import the summary stats files 
SST.sumstat.Fernanda <- read.table('/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/SumStats/Fernanda_Alex_CMC_sumstats/CommonMind_ge_DLPFC_naive.permuted.sstprs.summarystats_prs1_prs2_v2.txt',header=T)

sumstat.Kevan <- read.table('/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/SumStats/SUMSTAT_SSTPRS_IRLgrey/CommonMind_ge_DLPFC_naive.permuted.sstprs.summarystats_prs1_prs2_v2.txt', header=T)

BMIsumstat <- fread("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/SumStats/raw_sumstats/GIANT-consortium.GWAS.Catalog/BMI_Height_GIANT.and.UKBioBank_2018/Meta-analysis_Locke_et_al.UKBiobank_2018_UPDATED.txt",header=T)
#2,336,269 SNPs


Bmi2 <- fread("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/SumStats/raw_sumstats/NHGRI-EBI.GWAS.Catalog /BMI_KoskeridisF/GCST90179150_buildGRCh37.tsv",header=T)
 


colnames(BMIsumstat)<-c("SNP", "A1", "A2", "Weight", "P")


merged=merge(BMIsumstat, dataset, by.x="SNP", by.y="V2") # the merge step
nrow(merged) #2,085,210
head(merged)



##############################################################################
## common SNps between GTEX and 

# BMI 
table(BMIsumstat$CHR)
# 1      2      3      4      5      6      7      8      9     10     11     12 
# 175116 205436 162881 151943 157163 160837 132399 137821 111968 127462 120746 114935 
# 13     14     15     16     17     18     19     20     21     22 
# 96020  77183  65428  64624  51733  70596  32974  57828  31185  29991 


table(merged$CHR) 
# 1      2      3      4      5      6      7      8      9     10     11     12 
# 155451 183305 146499 135061 140340 143256 118503 123380 100396 113293 108524 102165 
# 13     14     15     16     17     18     19     20     21     22 
# 84831  68656  58258  57723  46894  62856  29679  51175  28258  26707 

# this shows how many SNPs between GTeX and BMI.summarystats are in common per chromosome


##########################################
# SST.sumstats

table(sumstat.Kevan$chromosome)

#  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 
# 95 66 59 33 57 36 68 36 39 36 49 54  8 38 34 53 53 20 59 34  7 15  # number of SNPs in the SST.summary.stats

table(merged$chromosome)
# 29 25 19 10 18 14 29 14 15 11 22 19  3 14 13 16 16 8  26 15  5  6
# above are the number of variants in Gtex bim files matching the Fernanda's.sumstats file 


####################

# Raw PRS scores hitogram
Raw.scores <- read.csv("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores/BMI_GTeX_PRS_Raw.csv", header=TRUE)

setwd("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores")
# plot indiviual p.profiles
score_dir <- "/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores"
file_list <- list.files(path=score_dir,full.names = F, pattern="*\\.0.1.profile$")


# let's name the list
setattr(file_list, 'names', c("a", "b"))


#initiate a blank data frame, each iteration of the loop will append the data from the given file to this variable
scores <- data.frame()

#had to specify columns to get rid of the total column
for (i in 1:length(file_list)){
  temp_data <- fread(file_list[i], stringsAsFactors = F) #read in files using the fread function from the data.table package
  scores <- rbindlist(list(scores, temp_data), use.names = T, fill=TRUE, idcol=TRUE) #for each iteration, bind the new data to the building dataset
}


# plor the PRS Raw Scores distribution

library(data.table)
score_dir <- "/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores"

files <- list.files(path=score_dir,full.names = F, pattern="*\\.0.1.profile$")
file.list <- lapply(files, fread)
setattr(file.list, "names", files)
scorefiles <- rbindlist(file.list, idcol="ChrId")[, ChrId := substr(ChrId,start = 5, stop = 9)]

table(scorefiles$ChrId) 

scorefiles %>%
  group_by(ChrId)%>%
  ggplot(aes(x = SCORE)) + 
  geom_histogram(color = "black", fill = "skyblue")+
  facet_wrap(~ ChrId)+
  ggtitle(label = "BMI_PRS0.1")+
  theme_bw()







