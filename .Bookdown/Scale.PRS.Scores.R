
getwd()
# Alex
library(data.table)
sscorespath="/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores"
sscores=grep(list.files(path=sscorespath),pattern = ".profile", value = T)

phenoty=c(".0.1.",".0.5." , ".1.0.")
filefile0=fread("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores/out_chr1.0.1.profile")
filefile0=filefile0%>%dplyr::select(.,IID)
filefile=filefile0
for (pheno in phenoty){
  phenofile=grep(list.files(path=sscorespath),pattern = pheno, value = T)
  phenofile=grep(phenofile,pattern = ".profile",value=T)
  for (ph in phenofile){
    filetemp=paste0(sscorespath,"/",ph)
    temp=fread(filetemp)
    temp[[ph]]=temp$SCORE
    temp=temp%>%dplyr::select(.,ph)
    filefile=cbind.data.frame(filefile,temp)
  }
  sumprs=grep(colnames(filefile),pattern = pheno,value=T)
  tempsum=rowSums(filefile[,sumprs])
  filefile0=cbind.data.frame(filefile0,tempsum)
}

colnames(filefile0)=c("ID", phenoty) 
filefile0[,phenoty]=lapply(phenoty, function(x) scale(filefile0[[x]])) #z-score the PRS (mean=0, SD=1)
fwrite(filefile0,"/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores/BMI_GTeX_PRS_Scaled.csv", sep=',')

fwrite(filefile,"/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores/BMI_GTeX_PRS_Raw.csv", sep=',')


