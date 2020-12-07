import os
import sys
import re

inputFA = "FLASH_combined_unique_seqs.fa"

#--cluster_fast
OTUfa = "FLASH_combined_VSEARCH_cluster.fa"
OTUinfo = "FLASH_combined_VSEARCH_cluster.txt"
command = "/opt/vsearch-2.15.1/bin/vsearch --cluster_fast "+inputFA+" --id 0.97 --centroids "+OTUfa+" --uc "+OTUinfo
#os.system(command)

#--cluster_smallmem --usersort
OTUfa = "FLASH_combined_VSEARCH_cluster_smallMEM.fa"
OTUinfo = "FLASH_combined_VSEARCH_cluster_smallMEM.txt"
command = "/opt/vsearch-2.15.1/bin/vsearch --cluster_smallmem --usersort "+inputFA+" --id 0.98 --centroids "+OTUfa+" --uc "+OTUinfo
#os.system(command)

#--cluster_unoise
OTUfa = "FLASH_combined_VSEARCH_unoise.fa"
OTUinfo = "FLASH_combined_VSEARCH_unoise.txt"
command = "/opt/vsearch-2.15.1/bin/vsearch --cluster_unoise "+inputFA+" --id 0.98 --centroids "+OTUfa+" --uc "+OTUinfo
os.system(command)
