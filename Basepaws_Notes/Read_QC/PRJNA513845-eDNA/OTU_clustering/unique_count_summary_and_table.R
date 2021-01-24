seqFolder = "FLASH-Swarm_OTU-all"
seqType = "Swarm.all.FLASH_merged"
metaIn = "../DADA2/Cutadapt-filtered_read_counts-with_sequencer_and_FLASHcounts.txt"
metaOut =  "Cutadapt-filtered_read_counts-with_sequencer--FLASH_merged_read_counts--Swarm-all.txt"
countOut =  "Swarm-all-FLASH_merged_read_counts-greater_than_1_in_10000.txt"
lengthPlot =  "Swarm-all-FLASH_merged_read_length_distribution.png"
lengthOut =  "Swarm-all-FLASH_merged_read_length_distribution.txt"
min_plot_length=200
max_plot_length=300

#seqFolder = "FLASH-Swarm_OTU-min_2reads"
#seqType = "Swarm.min2reads.FLASH_merged"
#metaIn = "../DADA2/Cutadapt-filtered_read_counts-with_sequencer_and_FLASHcounts.txt"
#metaOut =  "Cutadapt-filtered_read_counts-with_sequencer--FLASH_merged_read_counts--Swarm-min2reads.txt"
#countOut =  "Swarm-min2reads-FLASH_merged_read_counts-greater_than_1_in_10000.txt"
#lengthPlot =  "Swarm-min2reads-FLASH_merged_read_length_distribution.png"
#lengthOut =  "Swarm-min2reads-FLASH_merged_read_length_distribution.txt"
#min_plot_length=200
#max_plot_length=300

#seqFolder = "FLASH-VSEARCH_OTU-min_2reads"
#seqType = "VSEARCH.min2reads.FLASH_merged"
#metaIn = "../DADA2/Cutadapt-filtered_read_counts-with_sequencer_and_FLASHcounts.txt"
#metaOut =  "Cutadapt-filtered_read_counts-with_sequencer--FLASH_merged_read_counts--VSEARCH-min2reads.txt"
#countOut =  "VSEARCH-min2reads-FLASH_merged_read_counts-greater_than_1_in_10000.txt"
#lengthPlot =  "VSEARCH-min2reads-FLASH_merged_read_length_distribution.png"
#lengthOut =  "VSEARCH-min2reads-FLASH_merged_read_length_distribution.txt"
#min_plot_length=200
#max_plot_length=300

min_length=1
max_length=600
#start from summary for merged reads, where outliers have already been removed

meta.table = read.table(metaIn, head=T, sep="\t")
print(dim(meta.table))

plotCol = rep("grey",nrow(meta.table))
plotCol[meta.table$Sequencer == "Illumina MiSeq"]="black"
plotCol[meta.table$Sequencer == "Illumina NovaSeq 6000"]="red"


mergedTotal =  c()
mergedUnique =  c()
mergedUnique_multi =  c()
obs_gt10k =  c()

png(lengthPlot)
for (i in 1:nrow(meta.table)){
	print(paste(i," : ",meta.table$Sample[i],sep=""))
	temp_file = paste(seqFolder,"/",meta.table$Sample[i],".count_table2",sep="")
	temp_table =  read.table(temp_file, head=T, sep="\t")
	print(dim(temp_table))
	
	mergedTotal[i] = sum(temp_table$Count)
	mergedUnique[i] = nrow(temp_table)
	
	temp_multiRead = temp_table[temp_table$Count > 1,]
	mergedUnique_multi[i]=nrow(temp_multiRead)
	
	temp_10k = floor(temp_table$Count/ mergedTotal[i] * 10000)
	obs_gt10k[i]=length(temp_10k[temp_10k > 0])
	
	temp_length_table =  tapply(temp_table$Count, temp_table$Length, sum) / sum(temp_table$Count)
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
	#print(names(temp_length_table))
	#print(match(names(temp_length_table),length_x))
	length_y[match(names(temp_length_table),length_x)]=as.numeric(temp_length_table)
	
	if(i == 1){
		plot(length_x[min_plot_length:max_plot_length],length_y[min_plot_length:max_plot_length],
			type="l",lwd=2,col=plotCol[i], ylim=c(0,1),
			xlab = "Merged Sequence Length", ylab = "Frequency",
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
}#end for (i in 1:nrow(meta.table))
dev.off()

write.table(data.frame(Sample=meta.table$Sample,length_mat), lengthOut, quote=F, sep="\t", row.names=F)

addTable = data.frame(total=mergedTotal, unique=mergedUnique, multread_unique=mergedUnique_multi, obs_gt10k)
colnames(addTable) = paste(seqType,colnames(addTable),sep=".")

meta.table = data.frame(meta.table, addTable)

write.table(meta.table, metaOut, quote=F, sep="\t", row.names=F)

#some tables have much larger number of rows -  so, focus on sequences with frequency of greater than 1 in 10,000 for table