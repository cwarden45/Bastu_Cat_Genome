import os
import sys
import re

inputFA = "FLASH_combined_unique_seqs-min_2_reads-swarm_format.fa"
outputFA = "FLASH_combined_unique_seqs-min_2_reads-swarm_OTU.fa"
output_file = "FLASH_combined_unique_seqs-min_2_reads-swarm.txt"
output_file2 = "FLASH_combined_unique_seqs-min_2_reads-swarm.uclust"
output_file3 = "FLASH_combined_unique_seqs-min_2_reads-swarm.mothur"

#inputFA = "FLASH_combined_unique_seqs-swarm_format.fa"
#outputFA = "FLASH_combined_unique_seqs-swarm_OTU.fa"
#output_file = "FLASH_combined_unique_seqs-swarm.txt"
#output_file2 = "FLASH_combined_unique_seqs-swarm.uclust"
#output_file3 = "FLASH_combined_unique_seqs-swarm.mothur"

command = "/opt/swarm/bin/swarm -w "+outputFA+" -u "+output_file2+" "+inputFA+" > "+output_file
os.system(command)

command = "/opt/swarm/bin/swarm -r "+inputFA+" > "+output_file3
#os.system(command)

#I considered testing the `otuclust` function from micca (https://micca.readthedocs.io/en/latest/index.html).
#However, I believe the current version provides a wrapper for VSEARCH or Swarm, both of which I am testing.  Also, the precise OTU commands looks different? https://micca.readthedocs.io/en/latest/commands/otu.html