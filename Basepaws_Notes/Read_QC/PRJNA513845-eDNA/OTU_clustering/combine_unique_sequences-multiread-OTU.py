import os
import sys
import re

#min_reads=2
#inputFolder = "FLASH-Swarm_OTU-min_2reads"
#combinedFA = "FLASH_combined_unique_seqs-min_2_reads-Swarm_OTU_with_counts.fa"
#suffix = ".count_table2"

min_reads=100
inputFolder = "FLASH-Swarm_OTU-min_2reads"
combinedFA = "FLASH_combined_unique_seqs-min_2_reads--FILTER_OTU_MIN_100_READS-Swarm_OTU_with_counts.fa"
suffix = ".count_table2"

#read once to define seqs
print "Step 2) Generate Count Hash with Matching OTU Names"
countHash = {}
seqHash = {}

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
					if seqID in countHash:
						countHash[seqID]=countHash[seqID]+count
					else:
						countHash[seqID]=count
						seqHash[seqID]=seq
				
			line = inHandle.readline()
		inHandle.close()


print("Step 2) Writing OTUs with Total_Counts")
outHandle = open(combinedFA, 'w')

uniqueSeqs = countHash.keys()

for OTU_name in countHash.keys():
	uniSeq=seqHash[OTU_name]
	count = countHash[OTU_name]
	
	OTU_name = OTU_name+"_"+str(count)
	
	text = ">"+OTU_name+"\n"+uniSeq+"\n"
	outHandle.write(text)		

outHandle.close()