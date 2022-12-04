#!/bin/bash

#SAMPLEID=Basepaws_WGS1
#BAM=../../felCat9.gatk.bam

#SAMPLEID=Basepaws_WGS2
#BAM=../Basepaws_WGS2.felCat9.gatk.bam

#SAMPLEID=Nebula_lcWGS
#BAM=/home/cwarden/CDW_Genome/Nebula/BWA_MEM.nodup.bam

#SAMPLEID=SequencingDotCom_WGS
#BAM=/mnt/usb8/CDW_Genome/Sequencing.com/BWA_MEM.nodup.bam

SAMPLEID=Veritas_WGS
BAM=/mnt/usb8/CDW_Genome/Veritas/BWA_MEM.nodup.bam

#SAMPLEID=Bristle1
#BAM=/mnt/usb8/CDW_Genome/Bristle_Health/BWA_MEM.nodup.bam

OUTPUTTEXT=$SAMPLEID\_Picard_insert_stats.txt
OUTPUTPLOT=$SAMPLEID\_Picard_insert_hist.pdf

java -jar /opt/picard-v2.21.9.jar CollectInsertSizeMetrics I=$BAM O=$OUTPUTTEXT H=$OUTPUTPLOT M=0.5