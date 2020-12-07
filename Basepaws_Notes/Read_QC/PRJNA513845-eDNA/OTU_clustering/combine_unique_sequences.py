import os
import sys
import re
from Bio import SeqIO
from Bio.Seq import Seq

finishedSamples = [""]
inputFolder = "../DADA2/FLASH"
combinedFA = "FLASH_combined_unique_seqs.fa"
suffix = ".unique.fa"

uniqueHash = {}

fileResults = os.listdir(inputFolder)

for file in fileResults:
	result = re.search("(.*)"+suffix+"$",file)
	
	if result:
		sample = result.group(1)
		print(sample)
		
		inFA = inputFolder + "/" + file
		
		fasta_parser = SeqIO.parse(inFA, "fasta")
	
		for fasta in fasta_parser:
			seqID = fasta.id
			seq = str(fasta.seq)
			
			if seq  in uniqueHash:
				uniqueHash[seq]=uniqueHash[seq] + "_" + seqID
			else:
				uniqueHash[seq]=seqID

print("Writing Combined Sequences")
outHandle = open(combinedFA, 'w')

for uniSeq in uniqueHash:
	seqName = uniqueHash[uniSeq]
	
	text = ">"+seqName+"\n"+uniSeq+"\n"
	outHandle.write(text)
		
		
outHandle.close()