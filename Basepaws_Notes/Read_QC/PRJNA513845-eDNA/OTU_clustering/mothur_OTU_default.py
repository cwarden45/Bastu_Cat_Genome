import os
import sys
import re

inputFA = "FLASH_combined_unique_seqs-min_2_reads.fa"
refFA = "COI_ref.fa"

#If I only look at unique sequences that have at least 2 reads in 1 sample, then I see that I have to align the sequences first

command = "/opt/mothur/mothur \"#align.seqs(candidate="+inputFA+", template="+refFA+")\""
#os.system(command)

aln = re.sub(".fasta$",".align",inputFA)
aln = re.sub(".fa$",".align",aln)
command = "/opt/mothur/mothur \"#dist.seqs(fasta="+aln+", seed=1)\""
os.system(command)

#If I use all unique sequences, I run into issues with the job being killed for the previous step, before I could get to the cluster() step
#even with requiring only 2 reads in at least 1 sample, I think I still have to reduce the sequence count

dist = re.sub(".fasta$",".dist",inputFA)
dist = re.sub(".fa$",".dist",dist)

#more information available:https://mothur.org/wiki/otu-based_approaches/ and https://mothur.org/wiki/cluster/
#in general, there is also some additional information here: https://peerj.com/articles/1487/
#there is also a pre.cluster() option: https://mothur.org/wiki/pre.cluster/

#also run  get.oturep() ?