#!/bin/bash

#FA=../OTU_clustering/FLASH_combined_unique_seqs-min_2_reads-Swarm_OTU_with_counts.fa
#FQ=../OTU_clustering/FLASH_combined_unique_seqs-min_2_reads-Swarm_OTU_with_counts.fastq
#CONFIG=/opt/FastQ-Screen-0.14.1/fastq_screen.conf

FA=../OTU_clustering/FLASH_combined_unique_seqs-swarm_format.fa
FQ=../OTU_clustering/FLASH_combined_unique_seqs-swarm_format.fastq
CONFIG=/opt/FastQ-Screen-0.14.1/fastq_screen.conf


#following these instructions: https://www.biostars.org/p/199137/#199156
/opt/bbmap/reformat.sh in=$FA out=$FQ qfake=35

/opt/FastQ-Screen-0.14.1/fastq_screen --subset 0 --conf $CONFIG $FQ