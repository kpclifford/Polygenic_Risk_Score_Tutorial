# Before Imputation

Michigan Imputation Server accepts VCF files compressed with bgzip. 

Please make sure the following requirements are met:

Create a separate vcf.gz file for each chromosome.
Variations must be sorted by genomic position.
GRCh37 or GRCh38 coordinates are required.

To meet the abovementioned requirments, follow these steps: 

                                                           1. Data preparation: Quality Control for HRC or 1000G 
                                                                               
                                                           2. Create a frequency file
                     
                                                           3. Generate per chromosome .vcf files

                                                    
