
library(data.table)
library(tidyverse)
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
 

head(dataset) #5,462,632 rows

BMIsumstat=fread("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/SumStats/raw_sumstats/GIANT-consortium.GWAS.Catalog/BMI_Height_GIANT.and.UKBioBank_2018/Meta-analysis_Locke_et_al.UKBiobank_2018_UPDATED.txt",header=T)
colnames(BMIsumstat) #2,336,269
colnames(BMIsumstat)<-c("CHR", "POS","SNP", "A1", "A2", "Freq", "Beta", "SE", "P", "N")


SSTsumstat <- fread("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/3_GWAS_PRS_Workflow/SumStats/SUMSTAT_SSTPRS_IRLgrey/CommonMind_ge_DLPFC_naive.permuted.sstprs.summarystats_prs1_prs2_v2.txt",header=T) %>%
  select("chromosome", "position" , "rsid" , "ref", "alt" ,  "beta" , "weight_1" , "st_qvalue")
colnames(SSTsumstat) #949 rows
colnames(SSTsumstat)<-c("CHR", "POS","SNP", "A1", "A2", "Beta", "Weight", "P")


################################################################################
merged=merge(SSTsumstat, dataset, by.x="SNP", by.y="V2") # the merge step
nrow(merged) #2,085,210 row with BMI/ 349 with SST
head(merged)

### To mark ambiguous G/C or A/T SNPs for removal

## let’s create a column flagging the ambiguous SNPs
merged$ambiguousSNPs[merged$A1 == "A" & merged$A2 == "T"]<-1
merged$ambiguousSNPs[merged$A1 == "C" & merged$A2 == "G"]<-1
merged$ambiguousSNPs[merged$A1 == "G" & merged$A2 == "C"]<-1
merged$ambiguousSNPs[merged$A1 == "T" & merged$A2 == "A"]<-1

head(merged)


### To remove ambiguous SNPs

merged1=merged[is.na(merged$ambiguousSNPs),] # to remove ambiguous SNPs

nrow(merged1)      # number of non-unambiguous SNPs remained


### To find perfect allele matches (beta will be the same) 

merged1aa=merged1[as.character(merged1$A1) == merged1$V5 & as.character(merged1$A2) == merged1$V6,]

nrow(merged1aa)


### To find allele matches for flipped strand -- beta will be the same

merged1ab=merged1[merged1$A1 == "A" & merged1$A2 == "C" & merged1$V5 == "T" & merged1$V6 == "G",]
merged1ac=merged1[merged1$A1 == "A" & merged1$A2 == "G" & merged1$V5 == "T" & merged1$V6 == "C",]
merged1ad=merged1[merged1$A1 == "C" & merged1$A2 == "A" & merged1$V5 == "G" & merged1$V6 == "T",]
merged1ae=merged1[merged1$A1 == "C" & merged1$A2 == "T" & merged1$V5 == "G" & merged1$V6 == "A",]
merged1af=merged1[merged1$A1 == "G" & merged1$A2 == "A" & merged1$V5 == "C" & merged1$V6 == "T",]
merged1ag=merged1[merged1$A1 == "G" & merged1$A2 == "T" & merged1$V5 == "C" & merged1$V6 == "A",]
merged1ah=merged1[merged1$A1 == "T" & merged1$A2 == "C" & merged1$V5 == "A" & merged1$V6 == "G",]
merged1ai=merged1[merged1$A1 == "T" & merged1$A2 == "G" & merged1$V5 == "A" & merged1$V6 == "C",]
merged1a=rbind(merged1aa,merged1ab,merged1ac,merged1ad,merged1ae,merged1af,merged1ag,merged1ah,merged1ai)   # to combine all the datasets created above + merged1aa with non-ambiguous SNPs

nrow(merged1a)


### To add column W for Weight to be used in PRS; W=Weight for matching SNPs and W=-Weight for non-matching SNPs

merged1a$W=merged1a$Weight  #column “B” as the effect estimate

### To find perfect allele switches between A1 and A2

merged1ba=merged1[as.character(merged1$A1) == merged1$V6 & as.character(merged1$A2) == merged1$V5,]

nrow(merged1ba)


### To find flipped strands but perfect allele switches between A1 and A2

merged1bb=merged1[merged1$A1 == "A" & merged1$A2 == "C" & merged1$V5 == "G" & merged1$V6 == "T",]
merged1bc=merged1[merged1$A1 == "A" & merged1$A2 == "G" & merged1$V5 == "C" & merged1$V6 == "T",]
merged1bd=merged1[merged1$A1 == "C" & merged1$A2 == "A" & merged1$V5 == "T" & merged1$V6 == "G",]
merged1be=merged1[merged1$A1 == "C" & merged1$A2 == "T" & merged1$V5 == "A" & merged1$V6 == "G",]
merged1bf=merged1[merged1$A1 == "G" & merged1$A2 == "A" & merged1$V5 == "T" & merged1$V6 == "C",]
merged1bg=merged1[merged1$A1 == "G" & merged1$A2 == "T" & merged1$V5 == "A" & merged1$V6 == "C",]
merged1bh=merged1[merged1$A1 == "T" & merged1$A2 == "C" & merged1$V5 == "G" & merged1$V6 == "A",]
merged1bi=merged1[merged1$A1 == "T" & merged1$A2 == "G" & merged1$V5 == "C" & merged1$V6 == "A",]
merged1b=rbind(merged1ba,merged1bb,merged1bc,merged1bd,merged1be,merged1bf,merged1bg,merged1bh,merged1bi)

nrow(merged1b)


### NOTE: there are 11 SNPs with mismatching A1 and A2 between Base GWAS summary stat and target GWAS data

### NOTE: there are 0 INDELs with mismatching A1 and A2 between Base GWAS summary stat and target GWAS data

nrow(merged1b)+nrow(merged1a)

### W = -Weight for SNPs with switched A1 and A2
merged1b$W=0-merged1b$Weight
### ***NOTE: Use V5 as A1 & V6 as A2 & W as the effect estimate for each A1 in genotype*** 

merged2=rbind(merged1a,merged1b)

nrow(merged2) 
sum(is.na(merged2$ambiguousSNPs))
head(merged2)

## Saving the base-cleaned-alleles file to be used later
write.table(merged2,"/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/sumstats.QCed/SST_sumstat_QCed.txt",quote=F,sep='\t',col.names=T,row.names=F)


## Setting up and saving the file for clumping in the next step
merged2s=subset(merged2,select=c("SNP","P"))
colnames(merged2s)<-c("SNP","P")
write.table(merged2s,"/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/sumstats.QCed/SST_SNPs_P_forclumping.txt",quote=F,sep='\t',col.names=T,row.names=F)







