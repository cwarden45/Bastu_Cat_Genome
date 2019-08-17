#!/bin/bash

NAME=Bowtie2_Alignment
R1=../HCWGS0003.23.HCWGS0003_1.fastq.gz
R2=../HCWGS0003.23.HCWGS0003_2.fastq.gz

REF=FGF5_exons

SAM=$NAME.sam
BAM=$NAME.bam

/opt/bowtie2-2.3.5.1-linux-x86_64/bowtie2-build $REF.fa $REF

/opt/bowtie2-2.3.5.1-linux-x86_64/bowtie2 --no-unal -x $REF -1 $R1 -2 $R2 -S $SAM

/opt/samtools/samtools sort -O BAM -o $BAM $SAM

/opt/samtools/samtools index $BAM

rm $SAM