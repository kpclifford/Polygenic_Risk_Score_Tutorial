#### Descriptive pipeline for genotype imputation         
###### Author: Nickie Safarian                            
###### Date: February 03, 2023                            



## Imputation
Genotype imputation is a process of estimating missing genotypes from the haplotype or genotype reference panel.
It can effectively boost the power of detecting single nucleotide polymorphisms (SNPs) in genome-wide association studies (GWAS).

![Imputation](https://user-images.githubusercontent.com/102309428/219769864-46b67208-aed5-415f-b6de-0764a430fcc3.PNG)



### Tools
There are several software packages available to impute genotypes from a genotyping array to reference panels, such 
as 1000 Genomes Project haplotypes. These tools include MaCH Minimac, IMPUTE2 and Beagle. Each tool provides specific pros 
and cons in terms of speed and accuracy. 


### Imputation servers are already available at 

[https://imputation.sanger.ac.uk/]
[https://imputationserver.sph.umich.edu/]


### Reference Panels
In early imputation usage, haplotypes from HapMap populations were used as a reference panel, but this has been succeeded by the 
availability of haplotypes from the 1000 Genomes Project as reference panels with more samples, across more diverse populations, 
and with greater genetic marker density. 


Michigan imputation server (MIS) offers imputation from the several reference panels including:

   - [] The Haplotype Reference Consortium (HRC; Version r1.1 2016): The HRC panel consists of 64,940 haplotypes of predominantly    
         European ancestry.
   - [] 1000 Genomes Phase 3 (Version 5): Phase 3 of the 1000 Genomes Project consists of 5,008 haplotypes from 26 populations across 
         the world.
   
### Workflow 
There are three phases:

                       1.Before imputation, 
                       2. imputation job submission, 
                       3. Post-imputation QC, 
                       
that I will explain in this folder.
      
         
       
