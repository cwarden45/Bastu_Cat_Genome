lengthTableIn="PEAR_merged_read_length_distribution.txt"
metaIn = "Cutadapt-filtered_read_counts-with_sequencer_and_FLASHplusPEAR_counts.txt"
outlierPlotOut="PEAR_merged_outlier_length_percentage.png"
min_plot_length=200
max_plot_length=300

#lengthTableIn="FLASH_merged_read_length_distribution.txt"
#metaIn = "Cutadapt-filtered_read_counts-with_sequencer_and_FLASHplusPEAR_counts.txt"
#outlierPlotOut="FLASH_merged_outlier_length_percentage.png"
#min_plot_length=200
#max_plot_length=300

min_length=1
max_length=600

length.table = read.table(lengthTableIn, head=T, sep="\t")

meta.table = read.table(metaIn, head=T, sep="\t")

plotCol = rep("grey",nrow(meta.table))
plotCol[meta.table$Sequencer == "Illumina MiSeq"]="black"
plotCol[meta.table$Sequencer == "Illumina NovaSeq 6000"]="red"

outlierColumns = paste("L",c(min_length:(min_plot_length-1),(max_plot_length+1):max_length),sep="")

outlier.mat = length.table[,match(outlierColumns,names(length.table))]
rownames(outlier.mat)=length.table$Sample

outlier.percentage = 100 * apply(outlier.mat, 1, sum)

png(outlierPlotOut)
plot(meta.table$Sequencer, outlier.percentage,
	xlab="Sequencer",outline=FALSE,
	ylab=paste("Percent Outlier Merged Reads (",min_length,":",(min_plot_length-1)," , ",(max_plot_length+1),":",max_length,")",sep=""),
	col="gray")
points(jitter(as.numeric(meta.table$Sequencer)), outlier.percentage, pch=16)
dev.off()