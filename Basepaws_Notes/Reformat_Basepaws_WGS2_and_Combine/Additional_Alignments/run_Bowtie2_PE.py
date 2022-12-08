import os
import sys
import re

finishedSamples = [""]
inputFolder = "/mnt/usb8/Bastu_Cat_Genome/WGS2/fastp"
outputFolder = "Bowtie2_Bacteria11_Alignment"
suffix = "_R1-AltParam2.fastq.gz"

ref=" /home/cwarden/Ref/Custom_Ref/Bowtie2/WgsOralBacteria11"
bacteria_bed="Bacteria11.bed"
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
			command = "bowtie2 -p " + threads + " -x " + ref + " -1 " + FQ1+ " -2 " + FQ2 + " -S " + alnSam
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
