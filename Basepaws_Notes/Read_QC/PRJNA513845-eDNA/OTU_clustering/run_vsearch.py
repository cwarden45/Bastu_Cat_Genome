import os
import sys
import re

inputFA = "FLASH_combined_unique_seqs-min_2_reads.fa"

#--cluster_fast
OTUfa = "FLASH_combined_VSEARCH_cluster-min_2_reads.fa"
OTUinfo = "FLASH_combined_VSEARCH_cluster-min_2_reads.txt"
command = "/opt/vsearch-2.15.1/bin/vsearch --cluster_fast "+inputFA+" --id 0.97 --centroids "+OTUfa+" --uc "+OTUinfo
os.system(command)

#I think --cluster_smallmem --usersort could also work, but even the largest file doesn't crash (it just takes too long)

#I think --cluster_unoise is better when abundance can be used to give weights to certain sequences