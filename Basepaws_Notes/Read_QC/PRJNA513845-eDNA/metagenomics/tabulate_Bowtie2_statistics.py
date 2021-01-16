import os
import sys
import re

#skip_samples = ("")
#inputFolder = "COI_Bowtie2-FLASH"
#suffix="-DADA2_filtered_FQ_alignment_stats.log"
#statFile = "COI_Bowtie2-FLASH_Bowtie2_alignment_rate.txt"

#skip_samples = ("")
#inputFolder = "COI_Bowtie2-PEAR"
#suffix="-DADA2_filtered_FQ_alignment_stats.log"
#statFile = "COI_Bowtie2-PEAR_Bowtie2_alignment_rate.txt"

skip_samples = ("")
inputFolder = "mm10_Bowtie2-FLASH"
suffix="-DADA2_filtered_FQ_alignment_stats.log"
statFile = "mm10_Bowtie2-FLASH_Bowtie2_alignment_rate.txt"

#skip_samples = ("")
#inputFolder = "mm10_Bowtie2-PEAR"
#suffix="-DADA2_filtered_FQ_alignment_stats.log"
#statFile = "mm10_Bowtie2-PEAR_Bowtie2_alignment_rate.txt"


statHandle = open(statFile, 'w')
text = "Sample\tAlignment.Rate\n"
statHandle.write(text)

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)"+suffix+"$",file)
	
	if result:
		sample = result.group(1)
		if sample not in skip_samples:
			print sample
			alignment_rate = ""
			
			alignment_log = inputFolder + "/" + sample + suffix
			
			inHandle = open(alignment_log)
			line = inHandle.readline()
				
			lineCount = 0
				
			while line:
				line = re.sub("\n","",line)
				line = re.sub("\r","",line)
				
				lineCount+=1
				
				if lineCount == 6:
					alnResult = re.search("^(\d+.\d+)% overall",line)
					if alnResult:
						alignment_rate=alnResult.group(1)
					else:
						print "Error parsing percent aligned: " + line
						sys.exit()
				
				line = inHandle.readline()
			inHandle.close()

			text = sample + "\t"+alignment_rate+"\n"
			statHandle.write(text)
statHandle.close()