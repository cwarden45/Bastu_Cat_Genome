#!/bin/bash

INFA=../OTU_clustering/FLASH_combined_unique_seqs-min_2_reads--FILTER_OTU_MIN_100_READS-Swarm_OTU_with_counts.fa
OUTHITS=../OTU_clustering/FLASH_combined_unique_seqs-min_2_reads--FILTER_OTU_MIN_100_READS-Swarm_OTU_with_counts.megablast
THREADS=12

REF=/home/cwarden/Ref/BLAST/nt

#/opt/ncbi-blast-2.11.0+/bin/makembindex -input $REF -iformat blastdb

/opt/ncbi-blast-2.11.0+/bin/blastn -num_threads $THREADS -task megablast -use_index true -db $REF -query $INFA -out $OUTHITS -evalue 1e-05 -max_target_seqs 1 -outfmt "6 qseqid sseqid evalue bitscore length pident frames staxids sskingdoms sscinames scomnames sblastnames stitle qseq qstart qend"