import os
import sys
import re

finishedSamples = [""]
inputFolder = "../DADA2/FLASH"
outputFolder = "FLASH-FA"
suffix = ".unique.fa"

ref="/opt/mash-Linux64-v2.2/refseq.genomes.k21s1000.msh"

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
			outputFile = outputFolder + "/" + sample + "_MashScreen.tab"

			#use the "-w" parameter to avoid getting double hits for the same genome (and reads)
			command = "/opt/mash-Linux64-v2.2/mash screen -w "+ref+" "+read1+" > "+outputFile
			os.system(command)