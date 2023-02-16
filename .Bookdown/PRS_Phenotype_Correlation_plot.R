library(tidyverse)
library(data.table)
library(broom)

# import phenotype data
gtex_subjects_meta = read_delim('/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Phenotype_Data/phs000424.v8.pht002742.v8.p2.c1.GTEx_Subject_Phenotypes.GRU.txt.gz', delim = '\t', skip = 10)%>%
  select(c("SUBJID", "COHORT" , "SEX", "RACE" , "HGHT" , "WGHT" , "BMI"))

# import the PRS scores result
BMIPRS <- read.csv(file=file.path("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/8_BMI.PRS.scores/BMI_GTeX_PRS_Scaled.csv"))%>%
  separate(ID, into=c("firstID", "secondID"), remove=F, sep="_")

# merge the two data
merged.dt <- merge(BMIPRS, gtex_subjects_meta, by.x = "firstID", by.y="SUBJID") 
colnames(merged.dt)

# regression model
bmi.lm1 <- merged.dt %>% 
  do(tidy(lm(scale(PRS1.0) ~ scale(BMI),  data = .))) %>%
  mutate(padj= p.adjust(`p.value`, method="BH")) %>%
  mutate(term= recode(term,
                      `(Intercept)` = "Intercept", 
                      `scale(BMI)` = "BMI"))

bmi.lm1

# get the summary of the linear model
coef(lm(scale(PRS1.0) ~ scale(BMI),  data = merged.dt)) 
glance(lm(scale(PRS0.1) ~ scale(BMI),  data = merged.dt))


# plot
pdf("/external/rprshnas01/netdata_kcni/stlab/Nickie/GTEX_V8/Genotype_Data/0_GTEX_ALL.White.Subjects/9_BMI_PRS_Plots/PRS1.vs.BMI.pdf")
plot(merged.dt$BMI, merged.dt$PRS1.0)
abline(lm(merged.dt$PRS1.0 ~ merged.dt$BMI), col="green", lty=1, lwd=2)
mtext(text= "coef=0.076, padj=0.144") # manualy input based on the printed summary 
dev.off()








