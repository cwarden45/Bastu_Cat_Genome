seqType = "Swarm.min2reads.FLASH_merged"
meta.file =  "Cutadapt-filtered_read_counts-with_sequencer--FLASH_merged_read_counts--Swarm-min2reads.txt"


meta.table = read.table(meta.file, head=T, sep="\t")

plotCol = rep("grey",nrow(meta.table))
plotCol[meta.table$Sequencer == "Illumina MiSeq"]="black"
plotCol[meta.table$Sequencer == "Illumina NovaSeq 6000"]="red"


cutadapt_total = meta.table$Count
merged_total = meta.table[,paste(seqType,".total",sep="")]
unique_total = meta.table[,paste(seqType,".unique",sep="")]
unique_total_multi = meta.table[,paste(seqType,".multread_unique",sep="")]
unique_gt10k = meta.table[,paste(seqType,".obs_gt10k",sep="")]


### cutadapt total versus merged ###
png(paste(seqType,"_total_merged_versus_total_cutadapt.png",sep=""))
plot(cutadapt_total, merged_total,
	xlab="Total Cutadapt Reads",ylab="Total Merged Reads",
	pch=16, col=plotCol)
legend("top", legend = c("Illumina MiSeq","Illumina NovaSeq 6000"), col=c("black","red"),
		pch=16,xpd=T, inset=-0.1, ncol=2)

plot_x = 1:1000 * 100000

model_x=cutadapt_total[meta.table$Sequencer == "Illumina MiSeq"]
model_y=merged_total[meta.table$Sequencer == "Illumina MiSeq"]
miseqLm =  lm(model_y ~ model_x)
#lines(plot_x, predict(miseqLm, newdata=data.frame(model_x=plot_x)), 
#		col=rgb(0, 0, 0, alpha = 0.2))

model_x = cutadapt_total[meta.table$Sequencer == "Illumina NovaSeq 6000"]
model_y = merged_total[meta.table$Sequencer == "Illumina NovaSeq 6000"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0, 0, alpha = 0.2))
dev.off()

### merged versus unique ###
png(paste(seqType,"_unique_merged_versus_total_merged.png",sep=""))
plot(merged_total, unique_total,
	xlab="Total Merged Reads",ylab="Unique Merged Reads",
	pch=16, col=plotCol)
	
model_x = merged_total[meta.table$Sequencer == "Illumina NovaSeq 6000"]
model_y = unique_total[meta.table$Sequencer == "Illumina NovaSeq 6000"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0, 0, alpha = 0.2))
dev.off()

### merged versus unique (>1 read) ###
png(paste(seqType,"_unique_merged_multi-read_versus_total_merged.png",sep=""))
plot(merged_total, unique_total_multi,
	xlab="Total Merged Reads",ylab="Unique Merged Reads (>1 read per sample)",
	pch=16, col=plotCol)

model_x=merged_total[meta.table$Sequencer == "Illumina MiSeq"]
model_y=unique_total_multi[meta.table$Sequencer == "Illumina MiSeq"]
miseqLm =  lm(model_y ~ model_x)
lines(plot_x, predict(miseqLm, newdata=data.frame(model_x=plot_x)), 
		col=rgb(0, 0, 0, alpha = 0.2))

model_x = merged_total[meta.table$Sequencer == "Illumina NovaSeq 6000"]
model_y = unique_total_multi[meta.table$Sequencer == "Illumina NovaSeq 6000"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0, 0, alpha = 0.2))
dev.off()

### merged versus unique (>1 in 10,000) ###
png(paste(seqType,"_unique_merged_per10k_versus_total_merged.png",sep=""))
plot(merged_total, unique_gt10k,
	xlab="Total Merged Reads",ylab="Unique Merged Reads (>1 in 10,000 frequency)",
	pch=16, col=plotCol)

model_x=merged_total[meta.table$Sequencer == "Illumina MiSeq"]
model_y=unique_gt10k[meta.table$Sequencer == "Illumina MiSeq"]
#miseqLoess = loess(model_y ~ model_x, span=1.0)
#lines(plot_x, predict(miseqLoess, newdata=data.frame(model_x=plot_x)), 
#		col=rgb(0, 0, 0, alpha = 0.2))

model_x = merged_total[meta.table$Sequencer == "Illumina NovaSeq 6000"]
model_y = unique_gt10k[meta.table$Sequencer == "Illumina NovaSeq 6000"]
#novaseqLoess =  loess(model_y ~ model_x, span=1.0)
#lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
#		col=rgb(1, 0, 0, alpha = 0.2))
dev.off()