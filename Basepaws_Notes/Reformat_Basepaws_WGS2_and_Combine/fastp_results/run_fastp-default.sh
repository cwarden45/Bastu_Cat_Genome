#!/bin/bash

SAMPLEID=Basepaws_WGS1
R1=../../HCWGS0003.23.HCWGS0003_1.fastq.gz
R2=../../HCWGS0003.23.HCWGS0003_1.fastq.gz

#SAMPLEID=Basepaws_WGS2
#R1=../Basepaws_WGS2_R1.fastq.gz
#R2=../Basepaws_WGS2_R2.fastq.gz

#SAMPLEID=Veritas_WGS
#R1=/mnt/usb8/CDW_Genome/Veritas/veritas_wgs_R1.fastq.gz
#R2=/mnt/usb8/CDW_Genome/Veritas/veritas_wgs_R2.fastq.gz

#SAMPLEID=SequencingDotCom_WGS
#R1=/mnt/usb8/CDW_Genome/Sequencing.com/CharlesWarden-NG1J8B7TDM-30x-WGS-Sequencing_com-10-13-21.1.fq.gz
#R2=/mnt/usb8/CDW_Genome/Sequencing.com/CharlesWarden-NG1J8B7TDM-30x-WGS-Sequencing_com-10-13-21.2.fq.gz

#SAMPLEID=Nebula_lcWGS
#R1=/home/cwarden/CDW_Genome/Nebula/951023c1725b4b52b150c46469121abd_R1.fastq.gz
#R2=/home/cwarden/CDW_Genome/Nebula/951023c1725b4b52b150c46469121abd_R2.fastq.gz

#SAMPLEID=Bristle1
#R1=/mnt/usb8/CDW_Genome/Bristle_Health/BH3773Y4_R1.fastq.gz
#R2=/mnt/usb8/CDW_Genome/Bristle_Health/BH3773Y4_R2.fastq.gz


TRIM1=$SAMPLEID\_R1-DEFAULT.fastq.gz
TRIM2=$SAMPLEID\_R2-DEFAULT.fastq.gz
/home/cwarden/miniconda3/bin/fastp -i $R1 -I $R2 -o $TRIM1 -O $TRIM2

NEWHTML=$SAMPLEID\_fastp-DEFAULT.html
NEWJSON=$SAMPLEID\_fastp-DEFAULT.json
mv fastp.html $NEWHTML
mv fastp.json $NEWJSON