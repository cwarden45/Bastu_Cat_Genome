import os
import sys
import re

#copied and modified from https://github.com/cwarden45/DTC_Scripts/blob/master/Psomagen_Viome/Kraken2_analysis/run_Kracken2_Bracken-FASTQ-PE.py
#that was copied and modified from https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/basepaws_Dental_Health_Test/run_Kracken2_Bracken-FASTQ-PE.py

#finishedSamples = [""]
#inputFolder = "../Kraken-IN"
#outputFolder = "Kraken-OUT-k2_standard_20221209"
#suffix = "_R1.fastq.gz"

finishedSamples = [""]
inputFolder = "../../Kraken-IN-DOWNSAMPLE_1M"
outputFolder = "../Kraken-OUT-k2_standard_20221209-DOWNSAMPLE_1M"
suffix = "_R1.fastq.gz"

ref="/home/cwarden/Ref/Kraken2"

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
			read2 = re.sub("_R1.fastq.gz","_R2.fastq.gz",read1)
			outputFile = outputFolder + "/" + sample + "_Kraken2.kraken"
			reportFile = outputFolder + "/" + sample + "_Kraken2.kreport"

			##you can also add "--classified-out", but that file is relatively large.  So, I am omitting that for now.
			#classifiedFile = outputFolder + "/" + sample + "_Kraken2_classified.fastq"

			#I recieved a memory requirement error message when trying to run the "standard" database
			#so, I started to modify parameters based upon this discussion: https://github.com/DerrickWood/kraken2/issues/285
			command = "/opt/kraken2-2.0.8-beta/build/kraken2 --memory-mapping --paired --db "+ref+" --output "+outputFile+" --report "+reportFile+" "+read1+" "+read2
			os.system(command)

			brackenFile = outputFolder + "/" + sample + "_Kraken2.bracken"
			
			command = "/opt/Bracken-2.5/bracken -d "+ref+" -i "+reportFile+" -o "+brackenFile+" "
			os.system(command)