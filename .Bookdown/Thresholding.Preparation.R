
# set the working directory 
setwd("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/Clumped/Clumped.for.SST")

########################################

# read all clumped data and rbind 
## 1. create a list of the files from your clumped data directory
data_dir2 <- "/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/Clumped/Clumped.for.SST"
file_list2 <- list.files(path=data_dir2,full.names = F, pattern="*\\.clumped$")

## 2. initiate a blank data frame, each iteration of the loop will append the data from the given file to this variable
dataset2 <- data.frame()
#had to specify columns to get rid of the total column
for (i in 1:length(file_list2)){
  temp_data <- fread(file_list2[i], stringsAsFactors = F) #read in files using the fread function from the data.table package
  dataset2 <- rbindlist(list(dataset2, temp_data), use.names = T) #for each iteration, bind the new data to the building dataset
  }

## 3. check the data
library(knitr)
kable(dataset2[1:3, 11:12]) #5,440,208 rows/ SNPs  
table(dataset2$CHR)

#############################################

# import the QCed summary stat file
QCed.sumstat=fread("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/sumstats.QCed/SST_sumstat_QCed.txt")
colnames(QCed.sumstat) #2,336,269 rows/SNPs

###############################################

# merge the two data
merged=merge(QCed.sumstat, dataset2, by=c("SNP"="SNP")) # the merge step
nrow(merged) # 284,669 row/ SNps are retained with BMI data/ but only 299 SNPs with SST sumstats
head(merged)


##################################################

# 
merged_a=subset(merged,select=c("SNP","V5","W"))%>% as.data.frame
colnames(merged_a)<-c("SNP","A1","Score")
write.table(merged_a,"/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/For.Thresholding/ForSST/target_clumped_nothreshold.raw",col.names=T,row.names=F,quote=F,sep='\t')

merged_b=subset(merged,select=c("SNP","P.x"))%>% as.data.frame
write.table(merged_b,"/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/7_Clumping/For.Thresholding/ForSST/target_clumped_nothreshold.snppvalues",col.names=T,row.names=F,quote=F,sep='\t')

######################

# Also,
# In a text file, write:
0.1 0 0.1
0.5 0 0.5
1.0 0 1.0
#save as: range_list.txt















