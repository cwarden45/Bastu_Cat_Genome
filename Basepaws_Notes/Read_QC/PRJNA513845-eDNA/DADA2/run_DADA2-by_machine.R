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

machines = levels(mapping.table$instrument_model)
print(machines)
machines = c("Illumina NovaSeq 6000")
print(machines)

for (machine_name in machines){
	machine_output = gsub(" ","_",machine_name)
	print(machine_name)
	
	machine_table = mapping.table[mapping.table$instrument_model==machine_name,]
	print(dim(machine_table))

	fnFs = paste(read.folder,"/",machine_table$run_accession,"_1.fastq.gz",sep="")	
	fnRs = paste(read.folder,"/",machine_table$run_accession,"_2.fastq.gz",sep="")
	filtFs = paste(output.folder,"/",machine_table$run_accession,"_1.fastq.gz",sep="")
	filtRs = paste(output.folder,"/",machine_table$run_accession,"_2.fastq.gz",sep="")
	sample.names = mapping.table$run_accession

	out = filterAndTrim(fnFs, filtFs, fnRs, filtRs,
					rm.phix=TRUE, compress=TRUE)
					
	stat_table = data.frame(Sample=rownames(out),out)
	log_file = paste(machine_output,"_DADA2_Processed_Reads_stats.txt",sep="")
	write.table(stat_table, log_file, quote=F, sep="\t", row.names=F)
	
	#ran into memory problems with the next steps on my local/personal computer (with paired-end reads), so I split the task into 2 steps (which may or may not be optimal)
}#end for (machine_name in machines)