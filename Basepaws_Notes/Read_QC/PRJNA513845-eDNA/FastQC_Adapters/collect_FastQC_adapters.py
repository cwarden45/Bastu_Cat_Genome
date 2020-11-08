import sys
import re
import os


fastqcFolder = "../../Reads/QC"
adapterUniversal = "Illumina_Universal_Adapter-percentages.txt"
adapterSmall3 = "Illumina_Small_RNA_3prime_Adapter-percentages.txt"
adapterSmall5 = "Illumina_Small_RNA_5prime_Adapter-percentages.txt"
adapterNextera = "Nextera_Transposase_Sequence-percentages.txt"
adapterSOLID = "SOLID_Small_RNA_Adapter-percentages.txt"

max_length = 268

samples = []
positions = range(1,max_length)

universalHash = {}
small3hash = {}
small5hash = {}
nexteraHash = {}
solidHash = {}

#collect counts

module_flag = 0
last_pos=0

fileResults = os.listdir(fastqcFolder)

for subfolder in fileResults:
	result = re.search("(.*).html",subfolder)

	if result:		
		sample = result.group(1)
		
		readInfoFile = fastqcFolder + "/" + sample + "/fastqc_data.txt"
		
		if os.path.isfile(readInfoFile):
			sample = re.sub("_fastqc","",sample)
			print sample
			samples.append(sample)
			
			inHandle = open(readInfoFile)
			lines = inHandle.readlines()
			
			totalReads = ""
			
			for line in lines:
				line = re.sub("\n","",line)
				line = re.sub("\r","",line)

				if re.search("^>>END_MODULE",line):
					if(module_flag == 1):
						if last_pos < max_length:
							for j in range(last_pos+1,max_length+1):
								if len(samples)==1:					
									universalHash[j]="NA"
									small3hash[j]="NA"
									small5hash[j]="NA"
									nexteraHash[j]="NA"
									solidHash[j]="NA"
								else:
									universalHash[j]=universalHash[j] + "\tNA"
									small3hash[j]=small3hash[j] + "\tNA"
									small5hash[j]=small5hash[j] + "\tNA"
									nexteraHash[j]=nexteraHash[j] + "\tNA"
									solidHash[j]=solidHash[j] + "\tNA"		
				
					module_flag = 0
					last_pos = 0
				elif module_flag == 1:
					lineInfo = line.split("\t")
					pos = lineInfo[0]
					
					if re.search("-",pos):
						posArr = pos.split("-")
						for j in range(int(posArr[0]),int(posArr[1])+1):
							if(j > max_length):
								print "Need to extend max length to cover position: " + str(j)
								sys.exit()
							
							if len(samples)==1:					
								universalHash[j]=lineInfo[1]
								small3hash[j]=lineInfo[2]
								small5hash[j]=lineInfo[3]
								nexteraHash[j]=lineInfo[4]
								solidHash[j]=lineInfo[5]
							else:
								universalHash[j]=universalHash[j] + "\t" + lineInfo[1]
								small3hash[j]=small3hash[j] + "\t" + lineInfo[2]
								small5hash[j]=small5hash[j] + "\t" + lineInfo[3]
								nexteraHash[j]=nexteraHash[j] + "\t" + lineInfo[4]
								solidHash[j]=solidHash[j] + "\t" + lineInfo[5]		

							last_pos=int(j)
					else:
						pos = int(lineInfo[0])
						if(pos > max_length):
							print "Need to extend max length to cover position: " + pos
							sys.exit()
						
						if len(samples)==1:					
							universalHash[pos]=lineInfo[1]
							small3hash[pos]=lineInfo[2]
							small5hash[pos]=lineInfo[3]
							nexteraHash[pos]=lineInfo[4]
							solidHash[pos]=lineInfo[5]
						else:
							universalHash[pos]=universalHash[pos] + "\t" + lineInfo[1]
							small3hash[pos]=small3hash[pos] + "\t" + lineInfo[2]
							small5hash[pos]=small5hash[pos] + "\t" + lineInfo[3]
							nexteraHash[pos]=nexteraHash[pos] + "\t" + lineInfo[4]
							solidHash[pos]=solidHash[pos] + "\t" + lineInfo[5]		

						last_pos=int(pos)
				elif re.search("^#Position	Illumina Universal Adapter",line):
					module_flag = 1
					
			inHandle.close()


#output counts
universalHandle = open(adapterUniversal, 'w')
text = "Position\t" + "\t".join(samples) + "\n"
universalHandle.write(text)
for pos in positions:
	fastqc_values = universalHash[pos]
	text = str(pos) + "\t" + fastqc_values + "\n"
	universalHandle.write(text)
universalHandle.close()

small3Handle = open(adapterSmall3, 'w')
text = "Position\t" + "\t".join(samples) + "\n"
small3Handle.write(text)
for pos in positions:
	fastqc_values = small3hash[pos]
	text = str(pos) + "\t" + fastqc_values + "\n"
	small3Handle.write(text)
small3Handle.close()

small5Handle = open(adapterSmall5, 'w')
text = "Position\t" + "\t".join(samples) + "\n"
small5Handle.write(text)
for pos in positions:
	fastqc_values = small5hash[pos]
	text = str(pos) + "\t" + fastqc_values + "\n"
	small5Handle.write(text)
small5Handle.close()

nexteraHandle = open(adapterNextera, 'w')
text = "Position\t" + "\t".join(samples) + "\n"
nexteraHandle.write(text)
for pos in positions:
	fastqc_values = nexteraHash[pos]
	text = str(pos) + "\t" + fastqc_values + "\n"
	nexteraHandle.write(text)
nexteraHandle.close()

solidHandle = open(adapterSOLID, 'w')
text = "Position\t" + "\t".join(samples) + "\n"
solidHandle.write(text)
for pos in positions:
	fastqc_values = solidHash[pos]
	text = str(pos) + "\t" + fastqc_values + "\n"
	solidHandle.write(text)
solidHandle.close()