seqType = "Swarm.all.FLASH_merged"
meta.file =  "Cutadapt-filtered_read_counts-with_sequencer--FLASH_merged_read_counts--Swarm-all.txt"

#seqType = "Swarm.min2reads.FLASH_merged"
#meta.file =  "Cutadapt-filtered_read_counts-with_sequencer--FLASH_merged_read_counts--Swarm-min2reads.txt"

#seqType = "VSEARCH.min2reads.FLASH_merged"
#meta.file =  "Cutadapt-filtered_read_counts-with_sequencer--FLASH_merged_read_counts--VSEARCH-min2reads.txt"

sample_file = "../sample_info.txt"

meta.table = read.table(meta.file, head=T, sep="\t")

sample.table = read.table(sample_file, head=T, sep="\t")
print(dim(sample.table))
sample.table = sample.table[match(meta.table$Sample,as.character(sample.table$Sample)),]
print(dim(sample.table))

sequencer =  sample.table$Sequencer
amplicon =  sample.table$Amplicon
Group = as.factor(paste(sequencer," - ",amplicon,sep=""))
Group_levels = levels(Group)

group.colors = c("green","blue","orange","red")
plotCol = rep("grey",nrow(meta.table))
for (i in 1:length(Group_levels)){
	plotCol[Group == Group_levels[i]]=group.colors[i]
}#end for (i in 1:length(Group_levels))

cutadapt_total = meta.table$Count
merged_total = meta.table[,paste(seqType,".total",sep="")]
unique_total = meta.table[,paste(seqType,".unique",sep="")]
unique_total_multi = meta.table[,paste(seqType,".multread_unique",sep="")]
unique_gt10k = meta.table[,paste(seqType,".obs_gt10k",sep="")]


### cutadapt total versus merged ###
png(paste(seqType,"_total_merged_versus_total_cutadapt.png",sep=""))
par(mar=c(5,5,7,2))
plot(cutadapt_total, merged_total,
	xlab="Total Cutadapt Reads",ylab="Total Merged Reads",
	pch=16, col=plotCol)
legend("top", legend = Group_levels, col=group.colors,
		pch=16,xpd=T, inset=-0.15, ncol=2)

plot_x = 1:1000 * 100000

model_x = cutadapt_total[Group == "Illumina NovaSeq 6000 - FishE"]
model_y = merged_total[Group == "Illumina NovaSeq 6000 - FishE"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0, 0, alpha = 0.2))
		
model_x = cutadapt_total[Group == "Illumina NovaSeq 6000 - F230"]
model_y = merged_total[Group == "Illumina NovaSeq 6000 - F230"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0.5, 0, alpha = 0.2))
dev.off()

### merged versus unique ###
png(paste(seqType,"_unique_merged_versus_total_merged.png",sep=""))
par(mar=c(5,5,7,2))
plot(merged_total, unique_total,
	xlab="Total Merged Reads",ylab="Unique Merged Reads",
	pch=16, col=plotCol)
	
model_x = merged_total[Group == "Illumina NovaSeq 6000 - FishE"]
model_y = unique_total[Group == "Illumina NovaSeq 6000 - FishE"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0, 0, alpha = 0.2))
		
model_x = merged_total[Group == "Illumina NovaSeq 6000 - F230"]
model_y = unique_total[Group == "Illumina NovaSeq 6000 - F230"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0.5, 0, alpha = 0.2))

legend("top", legend = Group_levels, col=group.colors,
		pch=16,xpd=T, inset=-0.15, ncol=2)
dev.off()

### merged versus unique (>1 read) ###
png(paste(seqType,"_unique_merged_multi-read_versus_total_merged.png",sep=""))
par(mar=c(5,5,7,2))
plot(merged_total, unique_total_multi,
	xlab="Total Merged Reads",ylab="Unique Merged Reads (>1 read per sample)",
	pch=16, col=plotCol)

model_x=merged_total[Group == "Illumina MiSeq - FishE"]
model_y=unique_total_multi[Group == "Illumina MiSeq - FishE"]
miseqLm =  lm(model_y ~ model_x)
lines(plot_x, predict(miseqLm, newdata=data.frame(model_x=plot_x)), 
		col=rgb(0, 0, 1, alpha = 0.2))

model_x=merged_total[Group == "Illumina MiSeq - F230"]
model_y=unique_total_multi[Group == "Illumina MiSeq - F230"]
miseqLm =  lm(model_y ~ model_x)
lines(plot_x, predict(miseqLm, newdata=data.frame(model_x=plot_x)), 
		col=rgb(0, 1, 0, alpha = 0.2))

model_x = merged_total[Group == "Illumina NovaSeq 6000 - FishE"]
model_y = unique_total_multi[Group == "Illumina NovaSeq 6000 - FishE"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0, 0, alpha = 0.2))

model_x = merged_total[Group == "Illumina NovaSeq 6000 - F230"]
model_y = unique_total_multi[Group == "Illumina NovaSeq 6000 - F230"]
novaseqLoess =  loess(model_y ~ model_x, span=1.0)
lines(plot_x, predict(novaseqLoess, newdata=data.frame(model_x=plot_x)), 
		col=rgb(1, 0.5, 0, alpha = 0.2))
		
legend("top", legend = Group_levels, col=group.colors,
		pch=16,xpd=T, inset=-0.15, ncol=2)
dev.off()

### merged versus unique (>1 in 10,000) ###
png(paste(seqType,"_unique_merged_per10k_versus_total_merged.png",sep=""))
plot(merged_total, unique_gt10k,
	xlab="Total Merged Reads",ylab="Unique Merged Reads (>1 in 10,000 frequency)",
	pch=16, col=plotCol)
legend("top", legend = Group_levels, col=group.colors,
		pch=16,xpd=T, inset=-0.15, ncol=2)

dev.off()