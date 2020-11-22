import os
import sys
import re

finishedSamples = [""]
seqFolder = "FLASH"
suffix =  ".extendedFrags.fastq.gz"

fileResults = os.listdir(seqFolder)

for file in fileResults:
	result = re.search("(.*)"+suffix+"$",file)
	
	if result:
		sample = result.group(1)
		if sample not in finishedSamples:
			print(sample)

			#assumes that  I  have created a compressed version of the merged FASTQ file
			FQ = seqFolder+"/"+sample+suffix
			FA = seqFolder+"/"+sample+".fa"
			command = "gunzip -c "+FQ+" | /opt/fastx_toolkit/bin/fastq_to_fasta -Q33 -o "+FA
			os.system(command)
			
			unique_Seqs=seqFolder+"/"+sample+".unique.fa"
			countFile=seqFolder+"/"+sample+".count_table"
			command = "/opt/mothur/mothur \"#unique.seqs(fasta="+FA+", format=count)\""
			os.system(command)

			command = "rm "+FA
			os.system(command)
