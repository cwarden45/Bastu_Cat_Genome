import os
import sys
import re

#copied from https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/Additional_Alignments/run_BWA-MEM_PE.py

##don't re-align human samples, for this analysis
finishedSamples = ["Bristle1","Nebula_lcWGS","SequencingDotCom_WGS","Veritas_WGS"]
inputFolder = "/mnt/usb8/Bastu_Cat_Genome/WGS2/fastp"
outputFolder = "BWA-MEM_Human-hg19_Cat-felCat9-Bacteria11Virus10_Alignment"
ref=" /home/cwarden/Ref/Custom_Ref/BWA/hg19_felCat9_Bacteria11Virus10.fa"
bacteria_bed="Bacteria11Virus10.bed"
suffix = "_R1-AltParam2.fastq.gz"

threads = "4"
javaMem = "16g"

command = "mkdir " + outputFolder
os.system(command)

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)"+suffix+"$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			FQ1=inputFolder + "/" + sample + "_R1-AltParam2.fastq.gz"
			FQ2=inputFolder + "/" + sample + "_R2-AltParam2.fastq.gz"

			alnSam = outputFolder + "/temp.sam"
			command = "/opt/bwa-0.7.17/bwa mem -t " + threads + " " + ref + " " + FQ1+ " " + FQ2 + " > " + alnSam
			os.system(command)

			tempBam = outputFolder + "/temp.bam"
			command = "/opt/samtools/samtools view -b " + alnSam+ " > " + tempBam
			os.system(command)

			command = "rm " + alnSam
			os.system(command)

			rgBam=outputFolder + "/rg.bam"
			command = "java -Xmx" + javaMem + " -jar /opt/picard-v2.21.9.jar AddOrReplaceReadGroups I=" + tempBam + " O=" + rgBam + " SO=coordinate RGID=1 RGLB=WGA RGPL=Illumina RGPU=Veritas RGSM=realign"
			os.system(command)

			command = "rm " + tempBam
			os.system(command)

			command = "samtools index " + rgBam
			os.system(command)

			nodupBam=outputFolder + "/nodup.bam"
			duplicateMetrics = outputFolder + "/" + sample+"_MarkDuplicates_BWA_MEM_metrics.txt"
			command = "java -jar -Xmx" + javaMem + " /opt/picard-v2.21.9.jar MarkDuplicates INPUT=" + rgBam + " OUTPUT=" + nodupBam + " METRICS_FILE=" + duplicateMetrics + " REMOVE_DUPLICATES=true CREATE_INDEX=True"
			os.system(command)

			statsFile = outputFolder + "/" + sample+"_idxstats.txt"
			command = "/opt/samtools/samtools idxstats " + nodupBam + " > " + statsFile
			os.system(command)

			bacterialBam = outputFolder + "/" + sample+".bacteria.bam"
			command = "/opt/bedtools2/bin/bedtools intersect -abam " + nodupBam + " -b " + bacteria_bed + " > "+ bacterialBam
			os.system(command)

			command = "/opt/samtools/samtools index " + bacterialBam
			os.system(command)

			command = "rm " + nodupBam
			os.system(command)

			noDupIndex = outputFolder + "/nodup.bai"
			command = "rm " + noDupIndex
			os.system(command)
