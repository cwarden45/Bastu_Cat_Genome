import sys
import re
import os

read1 = "tyr.amp.tab.fasta"
samOut = "tyr.amp-felCat9.gatk.sam"
bamOut = "tyr.amp-felCat9.gatk.sorted.bam"
refFa = "../felCat9.fa"

#read1 = "tyr.amp.tab.fasta"
#samOut = "tyr.amp-felCat8.gatk.sam"
#bamOut = "tyr.amp-felCat8.gatk.sorted.bam"
#refFa = "../felCat8_Ref/felCat8.fa"

bwaThreads = "4"
javaMem = "6g"

print "\n\nRun BWA-MEM\n\n"
command = "/opt/bwa-0.7.17/bwa index -a bwtsw " + refFa
os.system(command)

command = "/opt/bwa-0.7.17/bwa mem -t " + bwaThreads + " " + refFa + " " + read1 + " > " + samOut
os.system(command)

print "\n\nSam-to-Bam and Sort/Add-Read-Groups\n\n"
tempBam = "temp.bam"
command = "/opt/samtools/samtools view -b " + samOut+ " > " + tempBam
os.system(command)

rgBam = re.sub(".bam$",".rg.bam",bamOut)
command = "java -Xmx" + javaMem + " -jar /opt/picard-v2.21.9.jar AddOrReplaceReadGroups I=" + tempBam + " O=" + bamOut + " SO=coordinate RGID=1 RGLB=AmpliconSeq RGPL=Illumina RGPU=Basepaws RGSM=align CREATE_INDEX=True"
os.system(command)

command = "rm " + tempBam
os.system(command)