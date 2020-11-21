import os
import sys
import re

finishedSamples = [""]
inputFolder = "DADA2_Processed_Reads"
outputFolder = "FLASH"

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)_1.fastq.gz$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			#run paired-end cutadapt
			gz1 = inputFolder + "/" + file
			gz2 = re.sub("_1.fastq","_2.fastq",gz1)

			#with multi-tasking, run with only 1 thread
			command = "/opt/FLASH-1.2.11-Linux-x86_64/flash -z -M 250 -t 1 -d "+outputFolder+" -o "+sample+" " + gz1 + " " + gz2
			os.system(command)