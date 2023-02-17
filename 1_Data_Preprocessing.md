#### Descriptive pipeline of GWA quality control approach       
###### Author: Nickie Safarian                                    
###### Date: January 20, 2023                                     


Here I explain how to prepare a Whole genome sequencing data for the downstream analysis: 

# Load modules

```{bash}
module load bio/VCFtools/0.1.14-foss-2018b-Perl-5.28.0
module load bio/BCFtools/1.9-foss-2018b 
module load bio/PLINK/1.90-beta5-foss-2018b
module load bio/PLINK2/2.00-alpha3-x86_64
module load R
```

## Step 1) Unstack the Data 

The Downloaded GTeX Genotye Data (The file name that I have used is: GTEx_Analysis_2016-01-15_v7_WholeGenomeSeq_652Ind_GATK_HaplotypeCaller.vcf.gz)
is stacked (i.e., is in .tar format) and needs to be Untared.



```{bash}
## to untar the file use:
$ cd /path/to/directory/you/like/to/keep/untar/Data/
$ tar -xvf path/to/vcf.tar OutputFileDirectroy/FileName.GRU.tar 
```
The output will be something like FileName.vcf.gz



## Step 2) Check Samples IDs in the WGS (.vcf.gz) data:

```{bash}
$ bcftools query -l FileName.vcf.gz

#To save the list of samples IDs
$ bcftools query -l FileName.vcf.gz > All_IDs.txt
```



## Step 3) Subset the .vcf.gz file to get the desired subset of samples (here being the White subjects)

Note: Use metdata to find the RACE information of GWAS subjects. The prepare a .txt file containing list of subjects (one per row)
that you wish to study. You can simply use R to do so. Here, my list is called White_IDs.txt, which contains the IDs (N=561) of Whit people in GTeX data. 

```{bash}
$ bcftools view -S White_IDs.txt -Oz -o White_subset_FileName.vcf.gz FileName.vcf.gz

# Also, extrat the index file
$ tabix -p vcf White_subset_FileName.vcf.gz
```

Note: This file is still super huge and it helps if we define the RAM useage (shown below) before conversion task.



## Step 4) Define the basic setups for RAM before the conversion task (vcf to bfile)

```{bash}
$ cd /to/the/folder/where/you/keep/White_subset_FileName.vcf.gz

#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=128000M
#SBATCH --time=12:00:00
#SBATCH --job-name="GTeX_WGS"
#SBATCH --output= /path/to/file/directory/gtex_wgs.out
#SBATCH --error= /path/to/file/directory/gtex_wgs.err       

$ plink --vcf White_subset_FileName.vcf.gz --make-bed --out GTeX_White  
## This code will convert a vcf genotype file into .bed+.fam+.bim files (PLINK bfiles).  

## Note: Instead of the above mentioned SBATCH steps you can simply use --memory flag of PLINK:
$ plink --memory 128000 --vcf White_subset_FileName.vcf.gz --make-bed --out GTeX_White 

```

#### Now the data is ready for QC. 

