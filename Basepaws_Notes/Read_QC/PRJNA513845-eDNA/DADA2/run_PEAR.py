import os
import sys
import re

finishedSamples = ["SRR8423864"]
inputFolder = "DADA2_Processed_Reads"
outputFolder = "PEAR"

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)_1.fastq.gz$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			#run paired-end cutadapt
			read1 = inputFolder + "/" + file
			read2 = re.sub("_1.fastq","_2.fastq",read1)

			pearPrefix = outputFolder + "/" + sample

			#with multi-tasking, run with only 1 thread
			command = "/opt/pear-0.9.11-linux-x86_64/bin/pear -f " + read1 + " -r " + read2 + " -o " + pearPrefix + " -j 1"
			os.system(command)
			
			assembledFQ = outputFolder + "/" + sample + ".assembled.fastq"
			command = "gzip " + assembledFQ
			os.system(command)

			command = "rm " + outputFolder + "/" + sample + ".discarded.fastq"
			os.system(command)
			
			command = "rm " + outputFolder + "/" + sample + ".unassembled.forward.fastq"
			os.system(command)

			command = "rm " + outputFolder + "/" + sample + ".unassembled.reverse.fastq"
			os.system(command)