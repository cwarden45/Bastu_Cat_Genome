meta.file = "../PRJNA513845.txt"
universal.file = "Cutadapt-filtered_Illumina_Universal_Adapter-percentages.txt"
nextera.file = "Cutadapt-filtered_Nextera_Transposase_Sequence-percentages.txt"
small3.file = "Cutadapt-filtered_Illumina_Small_RNA_3prime_Adapter-percentages.txt"
small5.file = "Cutadapt-filtered_Illumina_Small_RNA_5prime_Adapter-percentages.txt"
solid.file = "Cutadapt-filtered_SOLID_Small_RNA_Adapter-percentages.txt"

statIn="Cutadapt-filtered_read_counts.txt"
statOut="Cutadapt-filtered_read_counts-with_sequencer.txt"
statPlot="Cutadapt-filtered_read_counts-with_sequencer.png"

plot.max = log10(5)+1
plot.min = -10
outliers = c("SRR8423822","SRR8423819","SRR8423847","SRR8423820")

stat.table = read.table(statIn, head=T, sep="\t")
stat.samples = as.character(stat.table$Sample)
stat.samples = stat.samples[grep("_1$",stat.samples)]
read.counts = stat.table$Count[match(stat.samples,stat.table$Sample)]
stat.samples = gsub("_1$","",stat.samples)

meta.table = read.table(meta.file, head=T, sep="\t")
sequencer = meta.table$instrument_model[match(stat.samples,meta.table$run_accession)]
stat.table = data.frame(Sample=stat.samples, Count=read.counts,  Sequencer=sequencer)
write.table(stat.table, statOut, quote=F, sep="\t", row.names=F)

png(statPlot)
plot(stat.table$Sequencer, stat.table$Count,
	xlab="Sequencer",ylab="Cutadapt Filtered Read Counts", col="gray")
points(jitter(as.numeric(stat.table$Sequencer)), stat.table$Count, pch=16)
dev.off()

stat.table = stat.table[stat.table$Count !=0,]
print(table(stat.table$Sequencer))

meta.table = meta.table[match(stat.table$Sample,meta.table$run_accession),]
print(dim(meta.table))

MiSeq_R1 = paste(meta.table$run_accession[meta.table$instrument_model=="Illumina MiSeq"],"_1",sep="")
MiSeq_R2 = paste(meta.table$run_accession[meta.table$instrument_model=="Illumina MiSeq"],"_2",sep="")
NovaSeq_R1 = paste(meta.table$run_accession[meta.table$instrument_model=="Illumina NovaSeq 6000"],"_1",sep="")
NovaSeq_R2 = paste(meta.table$run_accession[meta.table$instrument_model=="Illumina NovaSeq 6000"],"_2",sep="")

###########################
#### Universal Adapter ####
###########################
universal.table = read.table(universal.file, head=T, sep="\t")
universal_pos = universal.table$Position
universal_mat = universal.table[,2:ncol(universal.table)]
print(max(universal_mat,na.rm=T))
print(min(universal_mat[universal_mat != 0],na.rm=T))
universal_mat[universal_mat == 0]=10^(plot.min+1)

MiSeq_R1.mat = universal_mat[,match(MiSeq_R1,names(universal_mat))]
MiSeq_R2.mat = universal_mat[,match(MiSeq_R2,names(universal_mat))]
NovaSeq_R1.mat = universal_mat[,match(NovaSeq_R1,names(universal_mat))]
NovaSeq_R2.mat = universal_mat[,match(NovaSeq_R2,names(universal_mat))]

MiSeq_R1_avg = apply(MiSeq_R1.mat,1,mean)
MiSeq_R2_avg = apply(MiSeq_R2.mat,1,mean)
NovaSeq_R1_avg = apply(NovaSeq_R1.mat,1,mean)
NovaSeq_R2_avg = apply(NovaSeq_R2.mat,1,mean)

png("Cutadapt-filtered_FastQC_Universal_Adapter_Results.png", height=400, width=1200)
par(mfrow=c(1,2))
#R1
plot(universal_pos, log10(MiSeq_R1_avg), type = "l", lwd=2,
		col="black",
		main="Universal Adapter (R1)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R1.mat)){
	points(universal_pos,log10(MiSeq_R1.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(universal_pos, log10(NovaSeq_R1_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R1.mat)){
	points(universal_pos,log10(NovaSeq_R1.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R1.mat)[i] %in% paste(outliers,"_1",sep="")){
		print("Plotting outlier")
		points(universal_pos,log10(NovaSeq_R1.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
#R2
plot(universal_pos, log10(MiSeq_R2_avg), type = "l", lwd=2,
		col="black",
		main="Universal Adapter (R2)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R2.mat)){
	points(universal_pos,log10(MiSeq_R2.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(universal_pos, log10(NovaSeq_R2_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R2.mat)){
	points(universal_pos,log10(NovaSeq_R2.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R2.mat)[i] %in% paste(outliers,"_2",sep="")){
		print("Plotting outlier")
		points(universal_pos,log10(NovaSeq_R2.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
dev.off()

#########################
#### Nextera Adapter ####
#########################
nextera.table = read.table(nextera.file, head=T, sep="\t")
nextera_pos = nextera.table$Position
nextera_mat = nextera.table[,2:ncol(nextera.table)]
print(max(nextera_mat,na.rm=T))
print(min(nextera_mat[nextera_mat != 0],na.rm=T))
nextera_mat[nextera_mat == 0]=10^(plot.min+1)

MiSeq_R1.mat = nextera_mat[,match(MiSeq_R1,names(nextera_mat))]
MiSeq_R2.mat = nextera_mat[,match(MiSeq_R2,names(nextera_mat))]
NovaSeq_R1.mat = nextera_mat[,match(NovaSeq_R1,names(nextera_mat))]
NovaSeq_R2.mat = nextera_mat[,match(NovaSeq_R2,names(nextera_mat))]

MiSeq_R1_avg = apply(MiSeq_R1.mat,1,mean)
MiSeq_R2_avg = apply(MiSeq_R2.mat,1,mean)
NovaSeq_R1_avg = apply(NovaSeq_R1.mat,1,mean)
NovaSeq_R2_avg = apply(NovaSeq_R2.mat,1,mean)

png("Cutadapt-filtered_FastQC_Nextera_Adapter_Results.png", height=400, width=1200)
par(mfrow=c(1,2))
#R1
plot(nextera_pos, log10(MiSeq_R1_avg), type = "l", lwd=2,
		col="black",
		main="Nextera Adapter (R1)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R1.mat)){
	points(nextera_pos,log10(MiSeq_R1.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(nextera_pos, log10(NovaSeq_R1_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R1.mat)){
	points(nextera_pos,log10(NovaSeq_R1.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R1.mat)[i] %in% paste(outliers,"_1",sep="")){
		print("Plotting outlier")
		points(nextera_pos,log10(NovaSeq_R1.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
#R2
plot(nextera_pos, log10(MiSeq_R2_avg), type = "l", lwd=2,
		col="black",
		main="Nextera Adapter (R2)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R2.mat)){
	points(nextera_pos,log10(MiSeq_R2.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(nextera_pos, log10(NovaSeq_R2_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R2.mat)){
	points(nextera_pos,log10(NovaSeq_R2.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R2.mat)[i] %in% paste(outliers,"_2",sep="")){
		print("Plotting outlier")
		points(nextera_pos,log10(NovaSeq_R2.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
dev.off()


##############################
#### Small RNA 3` Adapter ####
##############################
small3.table = read.table(small3.file, head=T, sep="\t")
small3_pos = small3.table$Position
small3_mat = small3.table[,2:ncol(small3.table)]
print(max(small3_mat,na.rm=T))
print(min(small3_mat[small3_mat != 0],na.rm=T))
small3_mat[small3_mat == 0]=10^(plot.min+1)

MiSeq_R1.mat = small3_mat[,match(MiSeq_R1,names(small3_mat))]
MiSeq_R2.mat = small3_mat[,match(MiSeq_R2,names(small3_mat))]
NovaSeq_R1.mat = small3_mat[,match(NovaSeq_R1,names(small3_mat))]
NovaSeq_R2.mat = small3_mat[,match(NovaSeq_R2,names(small3_mat))]

MiSeq_R1_avg = apply(MiSeq_R1.mat,1,mean)
MiSeq_R2_avg = apply(MiSeq_R2.mat,1,mean)
NovaSeq_R1_avg = apply(NovaSeq_R1.mat,1,mean)
NovaSeq_R2_avg = apply(NovaSeq_R2.mat,1,mean)

png("Cutadapt-filtered_FastQC_Small_RNA_3prime_Results.png", height=400, width=1200)
par(mfrow=c(1,2))
#R1
plot(small3_pos, log10(MiSeq_R1_avg), type = "l", lwd=2,
		col="black",
		main="Small RNA 3` Adapter (R1)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R1.mat)){
	points(small3_pos,log10(MiSeq_R1.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(small3_pos, log10(NovaSeq_R1_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R1.mat)){
	points(small3_pos,log10(NovaSeq_R1.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R1.mat)[i] %in% paste(outliers,"_1",sep="")){
		print("Plotting outlier")
		points(small3_pos,log10(NovaSeq_R1.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
#R2
plot(small3_pos, log10(MiSeq_R2_avg), type = "l", lwd=2,
		col="black",
		main="Small RNA 3` Adapter (R2)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R2.mat)){
	points(small3_pos,log10(MiSeq_R2.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(small3_pos, log10(NovaSeq_R2_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R2.mat)){
	points(small3_pos,log10(NovaSeq_R2.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R2.mat)[i] %in% paste(outliers,"_2",sep="")){
		print("Plotting outlier")
		points(small3_pos,log10(NovaSeq_R2.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
dev.off()

##############################
#### Small RNA 5` Adapter ####
##############################
small5.table = read.table(small5.file, head=T, sep="\t")
small5_pos = small5.table$Position
small5_mat = small5.table[,2:ncol(small5.table)]
print(max(small5_mat,na.rm=T))
print(min(small5_mat[small5_mat != 0],na.rm=T))
small5_mat[small5_mat == 0]=10^(plot.min+1)

MiSeq_R1.mat = small5_mat[,match(MiSeq_R1,names(small5_mat))]
MiSeq_R2.mat = small5_mat[,match(MiSeq_R2,names(small5_mat))]
NovaSeq_R1.mat = small5_mat[,match(NovaSeq_R1,names(small5_mat))]
NovaSeq_R2.mat = small5_mat[,match(NovaSeq_R2,names(small5_mat))]

MiSeq_R1_avg = apply(MiSeq_R1.mat,1,mean)
MiSeq_R2_avg = apply(MiSeq_R2.mat,1,mean)
NovaSeq_R1_avg = apply(NovaSeq_R1.mat,1,mean)
NovaSeq_R2_avg = apply(NovaSeq_R2.mat,1,mean)

png("Cutadapt-filtered_FastQC_Small_RNA_5prime_Results.png", height=400, width=1200)
par(mfrow=c(1,2))
#R1
plot(small5_pos, log10(MiSeq_R1_avg), type = "l", lwd=2,
		col="black",
		main="Small RNA 5` Adapter (R1)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R1.mat)){
	points(small5_pos,log10(MiSeq_R1.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(small5_pos, log10(NovaSeq_R1_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R1.mat)){
	points(small5_pos,log10(NovaSeq_R1.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R1.mat)[i] %in% paste(outliers,"_1",sep="")){
		print("Plotting outlier")
		points(small5_pos,log10(NovaSeq_R1.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
#R2
plot(small5_pos, log10(MiSeq_R2_avg), type = "l", lwd=2,
		col="black",
		main="Small RNA 5` Adapter (R2)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R2.mat)){
	points(small5_pos,log10(MiSeq_R2.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(small5_pos, log10(NovaSeq_R2_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R2.mat)){
	points(small5_pos,log10(NovaSeq_R2.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R2.mat)[i] %in% paste(outliers,"_2",sep="")){
		print("Plotting outlier")
		points(small5_pos,log10(NovaSeq_R2.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
dev.off()


#######################
#### SOLiD Adapter ####
#######################
solid.table = read.table(solid.file, head=T, sep="\t")
solid_pos = solid.table$Position
solid_mat = solid.table[,2:ncol(solid.table)]
print(max(solid_mat,na.rm=T))
print(min(solid_mat[solid_mat != 0],na.rm=T))
solid_mat[solid_mat == 0]=10^(plot.min+1)

MiSeq_R1.mat = solid_mat[,match(MiSeq_R1,names(solid_mat))]
MiSeq_R2.mat = solid_mat[,match(MiSeq_R2,names(solid_mat))]
NovaSeq_R1.mat = solid_mat[,match(NovaSeq_R1,names(solid_mat))]
NovaSeq_R2.mat = solid_mat[,match(NovaSeq_R2,names(solid_mat))]

MiSeq_R1_avg = apply(MiSeq_R1.mat,1,mean)
MiSeq_R2_avg = apply(MiSeq_R2.mat,1,mean)
NovaSeq_R1_avg = apply(NovaSeq_R1.mat,1,mean)
NovaSeq_R2_avg = apply(NovaSeq_R2.mat,1,mean)

png("Cutadapt-filtered_FastQC_SOLiD_Adapter_Results.png", height=400, width=1200)
par(mfrow=c(1,2))
#R1
plot(solid_pos, log10(MiSeq_R1_avg), type = "l", lwd=2,
		col="black",
		main="SOLiD Adapter (R1)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R1.mat)){
	points(solid_pos,log10(MiSeq_R1.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(solid_pos, log10(NovaSeq_R1_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R1.mat)){
	points(solid_pos,log10(NovaSeq_R1.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R1.mat)[i] %in% paste(outliers,"_1",sep="")){
		print("Plotting outlier")
		points(solid_pos,log10(NovaSeq_R1.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
#R2
plot(solid_pos, log10(MiSeq_R2_avg), type = "l", lwd=2,
		col="black",
		main="SOLiD Adapter (R2)",
		ylim=c(plot.min,plot.max),ylab="-log10(percent)",
		xlab="Read Position")
for (i in 1:ncol(MiSeq_R2.mat)){
	points(solid_pos,log10(MiSeq_R2.mat[,i]),
			col=rgb(0, 0, 0, alpha = 0.1),pch=16)
}#end for (i in 1:ncol(MiSeq_R1.mat))
lines(solid_pos, log10(NovaSeq_R2_avg), lwd=2, col="orange")
for (i in 1:ncol(NovaSeq_R2.mat)){
	points(solid_pos,log10(NovaSeq_R2.mat[,i]),
				col=rgb(1, 0.5, 0, alpha = 0.1),pch=16)
	if(names(NovaSeq_R2.mat)[i] %in% paste(outliers,"_2",sep="")){
		print("Plotting outlier")
		points(solid_pos,log10(NovaSeq_R2.mat[,i]),
				col="red",pch=16, cex=2)
	}
}#end for (i in 1:ncol(NovaSeq.mat))
legend("top", c("MiSeq","NovaSeq","NovaSeq-Outlier"), col=c("black","orange","red"),
		ncol=3, cex=1, lwd=2)
dev.off()
