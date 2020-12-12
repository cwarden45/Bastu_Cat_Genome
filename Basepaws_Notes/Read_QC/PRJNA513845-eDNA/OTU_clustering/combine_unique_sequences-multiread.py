import os
import sys
import re

finishedSamples = [""]
min_reads=2
inputFolder = "../DADA2/FLASH"
combinedFA = "FLASH_combined_unique_seqs-min_2_reads.fa"
suffix = ".count_table2"

uniqueHash = {}

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)"+suffix+"$",file)
	
	if result:
		sample = result.group(1)
		print(sample)
		
		count_table =  inputFolder + "/" +  file
		
		inHandle = open(count_table)
		line = inHandle.readline()
		
		line_count = 0
		
		while line:
			line = re.sub("\n","",line)
			line = re.sub("\r","",line)
			
			line_count +=1
			
			if line_count >1:
				lineInfo = line.split("\t")
				seq = lineInfo[0]
				seqID = lineInfo[1]
				count = int(lineInfo[2])
				
				if count >= min_reads:			
					if seq  in uniqueHash:
						uniqueHash[seq]=uniqueHash[seq] + "_" + seqID
					else:
						uniqueHash[seq]=seqID
				
			line = inHandle.readline()
		inHandle.close()

print("Writing Combined Sequences")
outHandle = open(combinedFA, 'w')

for uniSeq in uniqueHash:
	seqName = uniqueHash[uniSeq]
	
	text = ">"+seqName+"\n"+uniSeq+"\n"
	outHandle.write(text)
		
		
outHandle.close()