import os
import sys
import re

#copied and modified from https://github.com/cwarden45/DTC_Scripts/blob/master/Psomagen_Viome/Kraken2_analysis/run_Kracken2_Bracken-FASTQ-PE.py
#that was copied and modified from https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/basepaws_Dental_Health_Test/run_Kracken2_Bracken-FASTQ-PE.py

downsample_count = 1000000
downsample_ID = "DOWNSAMPLE_1M"
finishedSamples = [""]
inputFolder = "Kraken-IN" #run one level up, since Kraken2 with full reads for larger database is still running
outputFolder = "Kraken-IN-" + downsample_ID
suffix = "_R1.fastq.gz"

command = "mkdir " + outputFolder
os.system(command)

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)"+suffix+"$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			read1in = inputFolder + "/" + file
			read2in = re.sub("_R1.fastq.gz","_R2.fastq.gz",read1in)

			read1out = outputFolder + "/" + sample + "-" + downsample_ID + suffix
			read2out = re.sub("_R1.fastq.gz","_R2.fastq.gz",read1out)

			#-s100 keeps a constant random seed, as described here: https://github.com/lh3/seqtk
			command = "/opt/seqtk/seqtk sample -s100 "+read1in+" "+str(downsample_count)+" > "+re.sub(".gz$","",read1out)
			os.system(command)

			command = "gzip "+re.sub(".gz$","",read1out)
			os.system(command)

			command = "/opt/seqtk/seqtk sample -s100 "+read2in+" "+str(downsample_count)+" > "+re.sub(".gz$","",read2out)
			os.system(command)
			
			command = "gzip "+re.sub(".gz$","",read2out)
			os.system(command)