import os
import sys
import re

inputFA = "FLASH_combined_unique_seqs.fa"

command = "/opt/mothur/mothur \"#dist.seqs(fasta="+inputFA+")\""
os.system(command)

#I ran into issues with the job being killed for the previous step, before I could get to the cluster() step

#more information available:https://mothur.org/wiki/otu-based_approaches/ and https://mothur.org/wiki/cluster/
#in general, there is also some additional information here: https://peerj.com/articles/1487/


#also run  get.oturep() ?