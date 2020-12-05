import os
import sys
import re

finishedSamples = [""]
inputFolder = "../DADA2/FLASH"
outputFolder = "FLASH-FA"
suffix = ".unique.fa"

ref="/home/cwarden/Ref/BLAST/nt"

command = "/opt/ncbi-blast-2.11.0+/bin/makembindex -input "+ref+" -iformat blastdb"
os.system(command)

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
			outputFile = outputFolder + "/" + sample + "_megablast.txt"

			#based upon code from https://github.com/IARCbioinfo/PVAmpliconFinder/blob/master/PVAmpliconFinder.sh
			command = "/opt/ncbi-blast-2.11.0+/bin/blastn -task megablast -use_index true -db "+ref+" -query "+read1+" -out "+outputFile+" -evalue 1e-05 -max_target_seqs 1 -num_threads 1 -outfmt \"6 qseqid sseqid evalue bitscore length pident frames staxids sskingdoms sscinames scomnames sblastnames stitle qseq qstart qend\""
			os.system(command)
			
			sys.exit()