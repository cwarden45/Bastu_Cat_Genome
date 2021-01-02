import os
import sys
import re

finishedSamples = [""]
alignment_param = " --local"
inputFolder = "../DADA2/FLASH"
outputFolder = "COI_Bowtie2-FLASH"
suffixIn = ".extendedFrags.fastq.gz"
suffixOut = "-DADA2_filtered_FQ_alignment_stats.log"

#finishedSamples = [""]
#alignment_param = " --local"
#inputFolder = "../DADA2/PEAR"
#outputFolder = "COI_Bowtie2-PEAR"
#suffixIn = ".assembled.fastq.gz"
#suffixOut = "-DADA2_filtered_FQ_alignment_stats.log"

#finishedSamples = [""]
#alignment_param = " --sensitive -f"
#inputFolder = "../OTU_clustering"
#outputFolder = "Combined_FASTA"
#suffixIn = ".fa"
#suffixOut = "-combined_alignment_stats.log"

#finishedSamples = [""]
#alignment_param = " --very-sensitive -f"
#inputFolder = "../OTU_clustering"
#outputFolder = "Combined_FASTA"
#suffixIn = ".fa"
#suffixOut = "-combined_alignment_stats.log"

#finishedSamples = [""]
#alignment_param = " --local --sensitive-local -f"
#inputFolder = "../OTU_clustering"
#outputFolder = "Combined_FASTA"
#suffixIn = ".fa"
#suffixOut = "-combined_alignment_stats.log"

#finishedSamples = [""]
#alignment_param = " --local --very-sensitive-local -f"
#inputFolder = "../OTU_clustering"
#outputFolder = "Combined_FASTA"
#suffixIn = ".fa"
#suffixOut = "-combined_alignment_stats.log"


refPrefix="../OTU_clustering/COI_ref"
threads = "2"

command = "/opt/bowtie2-2.3.5.1-linux-x86_64/bowtie2-build "+ refPrefix+".fa " +  refPrefix
#os.system(command)

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
			alignmentReport = outputFolder +  "/" + sample + suffixOut
			
			command = "/opt/bowtie2-2.3.5.1-linux-x86_64/bowtie2 -p "+threads+alignment_param+" -x "+refPrefix+" -U "+read1+" -S "+tempSam+" 2> "+alignmentReport
			os.system(command)

			command = "rm "+tempSam
			os.system(command)