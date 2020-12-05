import os
import sys
import re

##skip empty Kracken2 files
#skip_samples = ("SRR8423878")
#classificationFolder = "FLASH-FQ"
#statFile = "FLASH_merged_Kraken2-Bracken_domain_counts.txt"

#remove sample that only had 21 reads
skip_samples = ("SRR8423878")
classificationFolder = "SRA-FQ"
statFile = "SRA-downloaded_Kraken2-Bracken_domain_counts.txt"


statHandle = open(statFile, 'w')
text = "Sample\tKraken2.Classification_Rate\tKraken2.Bacteria\tBracken.Bacteria\n"
statHandle.write(text)

fileResults = os.listdir(classificationFolder)

for file in fileResults:
	result = re.search("(.*)_Kraken2.kreport$",file)
	
	if result:
		sample = result.group(1)
		if sample not in skip_samples:
			print sample
			classfication_rate = ""
			total_bacteria = ""
			relative_bacteria = "NA"
			
			kraken2_report = classificationFolder + "/" + sample + "_Kraken2.kreport"
			braken_report = classificationFolder + "/" + sample + "_Kraken2_bracken.kreport"
			
			##parse classification and unadjusted bacterial counts
			inHandle = open(kraken2_report)
			line = inHandle.readline()
				
			while line:
				line = re.sub("\n","",line)
				line = re.sub("\r","",line)
				
				lineInfo = line.split("\t")
				percent =  lineInfo[0]
				level = lineInfo[3]
				name = lineInfo[5]
				
				if level == "U":
					classfication_rate = str(100-float(percent))
				elif level == "D":
					bacteriaResult = re.search("\s+Bacteria$",name)
					if bacteriaResult:
						total_bacteria=percent
					#print line
					#print "|" + name + "|"
				
				line = inHandle.readline()
			inHandle.close()
			
			##parse adjusted bacterial counts
			inHandle = open(braken_report)
			line = inHandle.readline()
				
			while line:
				line = re.sub("\n","",line)
				line = re.sub("\r","",line)
				
				lineInfo = line.split("\t")
				percent =  lineInfo[0]
				level = lineInfo[3]
				name = lineInfo[5]
				
				if level == "D":
					bacteriaResult = re.search("\s+Bacteria$",name)
					if bacteriaResult:
						relative_bacteria=percent
					#print line
					#print "|" + name + "|"
				
				line = inHandle.readline()
			inHandle.close()

			text = sample + "\t"+classfication_rate+"\t"+total_bacteria+"\t"+relative_bacteria+"\n"
			statHandle.write(text)
statHandle.close()