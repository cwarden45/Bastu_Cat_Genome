#!/bin/bash

NAME=BWA-MEM_Alignment
R1=../HCWGS0003.23.HCWGS0003_1.fastq.gz
R2=../HCWGS0003.23.HCWGS0003_2.fastq.gz

REF=FGF5_exons
THREADS=4

SAM1=$NAME\_full.sam
SAM2=$NAME.sam
BAM=$NAME.bam

/opt/bwa.kit/bwa index  -a bwtsw $REF.fa

/opt/bwa.kit/bwa mem -t $THREADS $REF.fa $R1 $R2 > $SAM1

/opt/samtools/samtools view -h -F 4 $SAM1 > $SAM2

#rm $SAM1

/opt/samtools/samtools sort -O BAM -o $BAM $SAM2

/opt/samtools/samtools index $BAM

#rm $SAM2