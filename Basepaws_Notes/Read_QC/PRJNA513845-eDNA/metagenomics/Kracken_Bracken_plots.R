#meta.file = "../sample_info.txt"
#classification.file = "FLASH_merged_Kraken2-Bracken_domain_counts.txt"
#boxplot.file = "FLASH_merged_Kraken2-Bracken_domain_counts.png"

meta.file = "../sample_info.txt"
classification.file = "SRA-downloaded_Kraken2-Bracken_domain_counts.txt"
boxplot.file = "SRA-downloaded_Kraken2-Bracken_domain_counts.png"

meta.table = read.table(meta.file, head=T, sep="\t")
classification.table = read.table(classification.file, head=T, sep="\t")

sequencer =  meta.table$Sequencer[match(classification.table$Sample,meta.table$Sample)]
amplicon =  meta.table$Amplicon[match(classification.table$Sample,meta.table$Sample)]

Group = as.factor(paste(sequencer," - ",amplicon,sep=""))

group.colors = c("green","blue","orange","red")

png(boxplot.file)
par(mar=c(3,5,7,2))
plot(Group, classification.table$Kraken2.Classification_Rate,
	xlab="Sequencer - Amplicon", ylab="Classification Rate", 
	ylim=c(0,100), xaxt = "n", col=group.colors)
mtext("Sequencer - Amplicon",side=1, line=1.5)
legend("top", levels(Group),col=group.colors,
	inset=-0.15, xpd=T, pch=15, ncol=2, cex=0.9)
dev.off()