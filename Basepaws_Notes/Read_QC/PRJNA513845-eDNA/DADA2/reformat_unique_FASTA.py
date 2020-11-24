import os
import sys
import re
from Bio import SeqIO
from Bio.Seq import Seq

seqFolder = "FLASH"
#seqFolder = "PEAR"

#use the ssunderlined sequence from the paper (non-degenerate portion) for a quick check of the ends (which is the same for F230 and Mini_SH-E)
primerF="TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG"
#I used one less nucleotide so that the lenghs would be the same, even though I don't think that matters
primerR="GTCTCGTGGGCTCGGAGATGTGTATAAGAGACA"
seqObj = Seq(primerR)
primerRrevcom = str(seqObj.reverse_complement())#TGTCTCTTATACACATCTCCGAGCCCACGAGAC

fileResults = os.listdir(seqFolder)

for file in fileResults:
	result = re.search("(.*).unique.fa$",file)
	
	if result:
		sample = result.group(1)
		print(sample)

		uniqueFA = seqFolder + "/" + file
		mothurCountTable = seqFolder + "/" +  sample + ".count_table"
		extendedCountTable = seqFolder + "/" +  sample + ".count_table2"
		
		#sequence counts
		countHash = {}
		
		inHandle = open(mothurCountTable)
		line = inHandle.readline()
					
		lineCount = 0
					
		while line:
			line = re.sub("\n","",line)
			line = re.sub("\r","",line)
			
			lineCount += 1
			
			if lineCount > 1:
				lineInfo = line.split("\t")
				seqID = lineInfo[0]
				seqCount = int(lineInfo[1])
				
				countHash[seqID]= seqCount

			line = inHandle.readline()
		
		inHandle.close()
		
		#FASTA conversion
		outHandle = open(extendedCountTable, 'w')
		#remove: \tFowardPrimer\tReversePrimer
		text = "Seq\tName\tCount\tLength\n"
		outHandle.write(text)
	
		fasta_parser = SeqIO.parse(uniqueFA, "fasta")
	
		for fasta in fasta_parser:
			seqID = fasta.id
			seq = str(fasta.seq)
			seqLength = len(seq)
				
			seqCount = 0
			if seqID in countHash:
				seqCount = countHash[seqID]
			else:
				print("Problem mapping: " + seqID)
				sys.exit()
			
			##I think something is not matching what I expected in the paper?
			#hitF="FALSE"
			#resultF = re.search("^"+primerF,seq)
			#if resultF:
			#	hitF="TRUE"
			#	print("OK-F")
			#	sys.exit()

			#hitR="FALSE"
			#resultF = re.search(primerRrevcom+"$",seq)
			#if resultF:
			#	hitF="TRUE"
			#	print("OK-R")
			#	sys.exit()
				
			#remove: +  "\t" + hitF  + "\t" +  hitR
			text = seq + "\t"  + seqID + "\t" + str(seqCount) + "\t" + str(seqLength) +  "\n"
			outHandle.write(text)
	
		outHandle.close()
		
		del countHash