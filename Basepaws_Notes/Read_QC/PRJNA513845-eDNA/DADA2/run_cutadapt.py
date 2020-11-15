import os
import sys
import re
from Bio.Seq import Seq

finishedSamples = ["SRR8423864"]
inputFolder = "../../Reads"
outputFolder = "../../Reads/Cutadapt_Trimmed_Reads"

#modified and updated for python3 from https://github.com/cwarden45/metagenomics_templates/blob/master/MiSeq_16S/cutadapt_filter.py

nexteraR = "CTGTCTCTTATA"
seqObj = Seq(nexteraR)
nexteraF = str(seqObj.reverse_complement())

fileResults = os.listdir(inputFolder)

command = "mkdir " + outputFolder
#os.system(command)

command = "mkdir " + outputFolder + "/QC"
#os.system(command)

for file in fileResults:
	result = re.search("(.*)_1.fastq.gz$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			#run paired-end cutadapt
			read1 = inputFolder + "/" + file
			read2 = re.sub("_1.fastq","_2.fastq",read1)

			trim1 = outputFolder + "/" + file
			trim2 = re.sub("_1.fastq","_2.fastq",trim1)

			command = "cutadapt --max-n 0 -a " + nexteraR + " -g " + nexteraF + " -A " + nexteraR + " -G " + nexteraF + " -m 20 -o " + trim1 + " -p " + trim2 + " " + read1 + " " + read2
			os.system(command)

			#run FastQC on R1
			command = "/opt/FastQC/fastqc -o "+outputFolder+"/QC " + trim1
			os.system(command)

			command= "unzip -d "+outputFolder+"/QC "+outputFolder+"/QC/"+sample+"_1_fastqc.zip"
			os.system(command)

			command = "rm "+outputFolder+"/QC/"+sample+"_1_fastqc.zip"
			os.system(command)

			command = "rm "+outputFolder+"/QC/"+sample+"_1_fastqc.html"
			os.system(command)

			#run FastQC on R2
			command = "/opt/FastQC/fastqc -o "+outputFolder+"/QC " + trim2
			os.system(command)

			command= "unzip -d "+outputFolder+"/QC "+outputFolder+"/QC/"+sample+"_2_fastqc.zip"
			os.system(command)

			command = "rm "+outputFolder+"/QC/"+sample+"_2_fastqc.zip"
			os.system(command)

			command = "rm "+outputFolder+"/QC/"+sample+"_2_fastqc.html"
			os.system(command)
