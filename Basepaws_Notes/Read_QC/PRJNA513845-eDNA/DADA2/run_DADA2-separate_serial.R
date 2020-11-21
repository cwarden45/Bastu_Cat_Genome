#use code example from https://benjjneb.github.io/dada2/

library(dada2)

read.folder = "../../Reads/Cutadapt_Trimmed_Reads"
output.folder = "DADA2_Processed_Reads"
mapping.file = "../PRJNA513845.txt"
cutadapt_stats="Cutadapt-filtered_read_counts-with_sequencer.txt"
log_file = "DADA2_Processed_Reads_stats.txt"

outliers =  c("SRR8423822","SRR8423819","SRR8423847","SRR8423820")

mapping.table = read.table(mapping.file, head=T, sep="\t")
print(dim(mapping.table))

stat.table = read.table(cutadapt_stats, head=T, sep="\t")
print(mapping.table$run_accession[-match(stat.table$Sample,mapping.table$run_accession)])
stat.table = stat.table[stat.table$Count !=0,]

mapping.table = mapping.table[match(stat.table$Sample,mapping.table$run_accession),]
print(dim(mapping.table))

mapping.table = mapping.table[-match(outliers,mapping.table$run_accession),]
print(dim(mapping.table))

for (i in 1:nrow(mapping.table)){
	sampleID =  mapping.table$run_accession[i]
	print(sampleID)
	
	fnFs = paste(read.folder,"/",sampleID,"_1.fastq.gz",sep="")
	fnRs = paste(read.folder,"/",sampleID,"_2.fastq.gz",sep="")
	filtFs = paste(output.folder,"/",sampleID,"_1.fastq.gz",sep="")
	filtRs = paste(output.folder,"/",sampleID,"_2.fastq.gz",sep="")
	sample.names = mapping.table$run_accession

	#out = filterAndTrim(fnFs, filtFs, fnRs, filtRs,
	#				rm.phix=TRUE, compress=TRUE)
					
	#stat_table = data.frame(Sample=rownames(out),out)
	#log_file = paste(sampleID,"_DADA2_Processed_Reads_stats.txt",sep="")
	#write.table(stat_table, log_file, quote=F, sep="\t", row.names=F)

	derepF = derepFastq(filtFs, verbose=TRUE)
	errF = learnErrors(derepF, multithread=FALSE)
	dadaFs = dada(filtFs, err=errF, multithread=FALSE)

	derepR = derepFastq(filtRs, verbose=TRUE)
	errR = learnErrors(derepR, multithread=FALSE)
	dadaRs = dada(filtRs, err=errR, multithread=FALSE)	
	
	mergers = mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)	
	seqtab = makeSequenceTable(mergers)

	#workspace_file = paste(output.folder,"/",sampleID,"_separate_DADA2.RData",sep="")
	#save.image(file = workspace_file)
	##contents can be accessed using load(workspace_file)
	
	merged_count_file = paste(output.folder,"/",sampleID,"_separate_DADA2_corrected_reads.txt",sep="")
	write.table(mergers, merged_count_file, quote=F, sep="\t", row.names=F)
}#end for (i in 1:nrow(mapping.table))