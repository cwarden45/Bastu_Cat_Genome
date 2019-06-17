#!/bin/bash

#0 aligned reads
NAME=Bastu_HighCov
R1=../Bastu_Genome/HCWGS0003.23.HCWGS0003_1.fastq.gz
R2=../Bastu_Genome/HCWGS0003.23.HCWGS0003_2.fastq.gz
REF=phiX


SAM=Alignments/$NAME.sam
BAM=Alignments/$NAME.bam

/opt/bowtie2-2.3.5.1-linux-x86_64/bowtie2 --no-unal -x $REF -1 $R1 -2 $R2 -S $SAM

/opt/samtools/samtools sort -O BAM -o $BAM $SAM

/opt/samtools/samtools index $BAM

rm $SAM