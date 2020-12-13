seqFolder = "DADA2_Processed_Reads"
seqType = "mergedDADA2_corrected"
metaIn = "Cutadapt-filtered_read_counts-with_sequencer_and_FLASHplusPEAR_counts.txt"
metaOut =  "DADA2_processed_read_summary.txt"
lengthPlot =  "DADA2_processed_read_length_distribution.png"
lengthOut =  "DADA2_processed_read_length_distribution.txt"
min_plot_length=200
max_plot_length=300

min_length=1
max_length=600

DADA.files = list.files(seqFolder, pattern="_separate_DADA2_corrected_reads.txt$")
sampleID = gsub("_separate_DADA2_corrected_reads.txt$","",DADA.files)

meta.table = read.table(metaIn, head=T, sep="\t")
print(dim(meta.table))
meta.table = meta.table[match(sampleID,as.character(meta.table$Sample)),]
print(dim(meta.table))

cutadapt_total = meta.table$Count

plotCol = rep("grey",nrow(meta.table))
plotCol[meta.table$Sequencer == "Illumina MiSeq"]="black"
plotCol[meta.table$Sequencer == "Illumina NovaSeq 6000"]="red"


mergedTotal =  c()
mergedUnique =  c()
mergedUnique_multi =  c()
obs_gt10k =  c()
outlierLengthPercent =  c()

png(lengthPlot)
for (i in 1:length(sampleID)){
	print(paste(i," : ",sampleID[i],sep=""))
	temp_file = paste(seqFolder,"/",sampleID[i],"_separate_DADA2_corrected_reads.txt",sep="")
	temp_table =  read.table(temp_file, head=T, sep="\t")
	print(dim(temp_table))

	merged_seqs = as.character(temp_table$sequence)
	merged_length = sapply(merged_seqs, nchar)
	
	mergedTotal[i] = sum(temp_table$abundance)
	mergedUnique[i] = nrow(temp_table)
	
	temp_multiRead = temp_table[temp_table$abundance > 1,]
	mergedUnique_multi[i]=nrow(temp_multiRead)
	
	temp_10k = floor(temp_table$abundance/ mergedTotal[i] * 10000)
	obs_gt10k[i]=length(temp_10k[temp_10k > 0])
	
	temp_length_table =  tapply(temp_table$abundance, merged_length, sum)
	outlier_lengths = c(min_length:(min_plot_length-1),(max_plot_length+1):max_length)
	temp_outlier_values = outlier_lengths[match(as.numeric(names(temp_length_table)),outlier_lengths,nomatch=0)]
	print(length(temp_outlier_values))
	counts_to_sum=temp_length_table[match(temp_outlier_values,as.numeric(names(temp_length_table)))]
	outlierLengthPercent[i]= 100 * sum(counts_to_sum)/mergedTotal[i]
	if(is.na(outlierLengthPercent[i])){
		print(temp_outlier_values )
		print(dim(temp_length_table))
		print(names(temp_length_table))
		print(counts_to_sum)
		print(mergedTotal[i])
		print(temp_outlier_values [is.na(counts_to_sum)])
		stop()
	}#end if(is.na(outlierLengthPercent[i]))
	
	temp_length_table = temp_length_table / mergedTotal[i]
	length_x = min_length:max_length
	length_y = rep(0,length(length_x))
	if(min(as.numeric(names(temp_length_table))) < min_length){
		print(paste("Need to make minimum length less than ",min(temp_length_table),sep=""))
		stop()
	}
	if(max(as.numeric(names(temp_length_table))) > max_length){
		print(paste("Need to make maximum length greater than ",max(temp_length_table),sep=""))
		stop()
	}
	length_y[match(names(temp_length_table),length_x)]=as.numeric(temp_length_table)
	
	if(i == 1){
		plot(length_x[min_plot_length:max_plot_length],length_y[min_plot_length:max_plot_length],
			type="l",lwd=2,col=plotCol[i], ylim=c(0,1),
			xlab = "Merged+Corrected Sequence Length", ylab = "Frequency",
			main="")
		legend("top", legend = c("Illumina MiSeq","Illumina NovaSeq 6000"), col=c("black","red"),
				xpd=T, inset=-0.1, lwd=3, ncol=2)
				
		names(length_y) = paste("L",length_x,sep="")
		length_mat = t(data.frame(length_y))
	}else{
		lines(length_x[min_plot_length:max_plot_length],length_y[min_plot_length:max_plot_length],
			lwd=2,col=plotCol[i])
		
		names(length_y) = paste("L",length_x,sep="")
		temp_length_mat = t(data.frame(length_y))
		length_mat=rbind(length_mat,temp_length_mat)
	}
}#end for (i in 1:length(sampleID))
dev.off()

write.table(data.frame(Sample=meta.table$Sample,length_mat), lengthOut, quote=F, sep="\t", row.names=F)

addTable = data.frame(total=mergedTotal, unique=mergedUnique, multread_unique=mergedUnique_multi, obs_gt10k)
colnames(addTable) = paste(seqType,colnames(addTable),sep=".")

meta.table = data.frame(meta.table, addTable)

write.table(meta.table, metaOut, quote=F, sep="\t", row.names=F)

### Outlier Length Percentage by Sequencer ###

png("DADA2-merged-and-corrected_outlier_length_percentage.png")
plot(meta.table$Sequencer, outlierLengthPercent,
	xlab="Sequencer",
	ylab=paste("Percent Outlier Merged Reads (",min_length,":",(min_plot_length-1)," , ",(max_plot_length+1),":",max_length,")",sep=""),
	col="gray")
points(jitter(as.numeric(meta.table$Sequencer)), outlierLengthPercent, pch=16)
dev.off()

### cutadapt total versus merged ###
png("DADA2-merged-and-corrected_total_merged_versus_total_cutadapt.png")
plot(cutadapt_total, mergedTotal,
	xlab="Total Cutadapt Reads",ylab="Total DADA2 Merged+Corrected Reads",
	pch=16, col=plotCol)
legend("top", legend = c("Illumina MiSeq","Illumina NovaSeq 6000"), col=c("black","red"),
		pch=16,xpd=T, inset=-0.1, ncol=2)

plot_x = 1:1000 * 100000

#model_x=cutadapt_total[meta.table$Sequencer == "Illumina MiSeq"]
#model_y=mergedTotal[meta.table$Sequencer == "Illumina MiSeq"]
#miseqLm =  lm(model_y ~ model_x)

#model_x = cutadapt_total[meta.table$Sequencer == "Illumina NovaSeq 6000"]
#model_y = mergedTotal[meta.table$Sequencer == "Illumina NovaSeq 6000"]
#novaseqLoess =  loess(model_y ~ model_x, span=1.0)
#lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
#		col=rgb(1, 0, 0, alpha = 0.2))
dev.off()

### merged versus unique ###
png("DADA2-merged-and-corrected_unique_merged_versus_total_merged.png")
plot(mergedTotal, mergedUnique,
	xlab="Total Merged Reads",ylab="Unique DADA2 Merged+Corrected Reads",
	pch=16, col=plotCol)
	
#model_x = mergedTotal[meta.table$Sequencer == "Illumina NovaSeq 6000"]
#model_y = mergedUnique[meta.table$Sequencer == "Illumina NovaSeq 6000"]
#novaseqLoess =  loess(model_y ~ model_x, span=1.0)
#lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
#		col=rgb(1, 0, 0, alpha = 0.2))
dev.off()

### merged versus unique (>1 read) ###
png("DADA2-merged-and-corrected_unique_merged_multi-read_versus_total_merged.png")
plot(mergedTotal, mergedUnique_multi,
	xlab="Total Merged Reads",ylab="Unique DADA2 Merged+Corrected Reads (>1 read per sample)",
	pch=16, col=plotCol)

#model_x=mergedTotal[meta.table$Sequencer == "Illumina MiSeq"]
#model_y=mergedUnique_multi[meta.table$Sequencer == "Illumina MiSeq"]
#miseqLm =  lm(model_y ~ model_x)
#lines(plot_x, predict(miseqLm, newdata=data.frame(model_x=plot_x)), 
#		col=rgb(0, 0, 0, alpha = 0.2))

#model_x = mergedTotal[meta.table$Sequencer == "Illumina NovaSeq 6000"]
#model_y = mergedUnique_multi[meta.table$Sequencer == "Illumina NovaSeq 6000"]
#novaseqLoess =  loess(model_y ~ model_x, span=1.0)
#lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
#		col=rgb(1, 0, 0, alpha = 0.2))
dev.off()

### merged versus unique (>1 in 10,000) ###
png("DADA2-merged-and-corrected_unique_merged_per10k_versus_total_merged.png")
plot(mergedTotal, obs_gt10k,
	xlab="Total Merged Reads",ylab="Unique DADA2 Merged+Corrected Reads (>1 in 10,000 frequency)",
	pch=16, col=plotCol)
dev.off()