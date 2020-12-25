#!/bin/bash
INFA=../OTU_clustering/FLASH_combined_unique_seqs-min_2_reads-Swarm_OTU_with_counts.fa
OUTHITS=../OTU_clustering/FLASH_combined_unique_seqs-min_2_reads-Swarm_OTU_with_counts.megablast

REF=/home/cwarden/Ref/BLAST/nt

#/opt/ncbi-blast-2.11.0+/bin/makembindex -input $REF -iformat blastdb

/opt/ncbi-blast-2.11.0+/bin/blastn -task megablast -use_index true -db $REF -query $INFA -out $OUTHITS -evalue 1e-05 -max_target_seqs 1 -num_threads 1 -outfmt "6 qseqid sseqid evalue bitscore length pident frames staxids sskingdoms sscinames scomnames sblastnames stitle qseq qstart qend"