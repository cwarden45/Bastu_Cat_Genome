import os
import sys
import re

#min_reads=2
#inputFolder = "../DADA2/FLASH"
#combinedFA = "FLASH_combined_unique_seqs-min_2_reads-swarm_format.fa"
#suffix = ".count_table2"

min_reads=1
inputFolder = "../DADA2/FLASH"
combinedFA = "FLASH_combined_unique_seqs-swarm_format.fa"
suffix = ".count_table2"

#read once to define seqs
print "Step 1) Generate Hash"
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

#read a second time to capture sequences present in 1 read in 1 sample but multiple reads in other samples
#Should not make much of a difference, but this is more precise count measure
print "Step 2) Sum Counts"
countHash = {}
for uniSeq in uniqueHash:
	countHash[uniSeq]=0
del uniqueHash

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
				
				if seq in countHash:
					countHash[seq]=countHash[seq]+count
				
			line = inHandle.readline()
		inHandle.close()


print("Step 3) Writing Combined Sequences")
outHandle = open(combinedFA, 'w')

uniqueSeqs = countHash.keys()

for i in xrange(0,len(uniqueSeqs)):
	uniSeq=uniqueSeqs[i]
	count = countHash[uniSeq]
	seqName = "Uniq"+str(i)+"_"+str(count)
	
	text = ">"+seqName+"\n"+uniSeq+"\n"
	outHandle.write(text)
		
		
outHandle.close()