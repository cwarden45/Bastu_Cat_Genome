import os
import sys
import re

finishedSamples = [""]
alignment_param = " "
inputFolder = "../DADA2/FLASH"
outputFolder = "mm10_Bowtie2-FLASH"
suffixIn = ".extendedFrags.fastq.gz"
suffixOut = "-DADA2_filtered_FQ_alignment_stats.log"

#finishedSamples = [""]
#alignment_param = " "
#inputFolder = "../DADA2/PEAR"
#outputFolder = "mm10_Bowtie2-PEAR"
#suffixIn = ".assembled.fastq.gz"
#suffixOut = "-DADA2_filtered_FQ_alignment_stats.log"

refPrefix="/home/cwarden/Ref/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome"
threads = "2"

command = "mkdir " + outputFolder
os.system(command)

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)"+suffixIn+"$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			read1 = inputFolder + "/" + file
			tempSam = outputFolder +  "/" + sample + ".sam"
			tempBam = outputFolder +  "/" + sample + ".sorted.bam"
			alignmentReport = outputFolder +  "/" + sample + suffixOut
			statFile = outputFolder +  "/" + sample + "_idxstats.txt"
			
			command = "/opt/bowtie2-2.3.5.1-linux-x86_64/bowtie2 -p "+threads+alignment_param+" -x "+refPrefix+" -U "+read1+" -S "+tempSam+" 2> "+alignmentReport
			os.system(command)

			command = "samtools sort -O BAM -o "+tempBam+"  "+tempSam
			os.system(command)

			command = "samtools index "+tempBam
			os.system(command)

			command = "samtools idxstats "+tempBam+" > "+statFile
			os.system(command)

			command = "rm "+tempSam
			os.system(command)

			command = "rm "+tempBam
			os.system(command)
			
			command = "rm "+tempBam + ".bai"
			os.system(command)