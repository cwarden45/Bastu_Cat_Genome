import os
import sys
import re

finishedSamples = [""]
inputFolder = "../DADA2/FLASH"
outputFolder = "FLASH-FQ"
suffix = ".extendedFrags.fastq.gz"

#finishedSamples = [""]
#inputFolder = "../DADA2/PEAR"
#outputFolder = "PEAR-FQ"
#suffix = ".assembled.fastq.gz"

ref="/opt/kraken2-2.0.8-beta/data/minikraken_8GB_20200312"

command = "mkdir " + outputFolder
os.system(command)

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)"+suffix+"$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			read1 = inputFolder + "/" + file
			outputFile = outputFolder + "/" + sample + "_Kraken2.kraken"
			reportFile = outputFolder + "/" + sample + "_Kraken2.kreport"

			##you can also add "--classified-out", but that file is relatively large.  So, I am omitting that for now.
			#classifiedFile = outputFolder + "/" + sample + "_Kraken2_classified.fastq"

			command = "/opt/kraken2-2.0.8-beta/build/kraken2 --db "+ref+" --output "+outputFile+" --report "+reportFile+" "+read1
			os.system(command)

			brackenFile = outputFolder + "/" + sample + "_Kraken2.bracken"
			
			command = "/opt/Bracken-2.5/bracken -d "+ref+" -i "+reportFile+" -o "+brackenFile+" "
			os.system(command)