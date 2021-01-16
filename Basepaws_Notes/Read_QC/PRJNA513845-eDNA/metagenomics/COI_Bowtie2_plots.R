#exclude.samples = c("SRR8423878")#exclude sample where log could not be parsed
#meta.file = "../sample_info.txt"
#alignment.file = "COI_Bowtie2-FLASH_Bowtie2_alignment_rate.txt"
#boxplot.file = "COI_Bowtie2-FLASH_Bowtie2_alignment_rate.png"

#exclude.samples = c("SRR8423878")#exclude sample where metadata is not  defined
#meta.file = "../sample_info.txt"
#alignment.file = "COI_Bowtie2-PEAR_Bowtie2_alignment_rate.txt"
#boxplot.file = "COI_Bowtie2-PEAR_Bowtie2_alignment_rate.png"

exclude.samples = c("SRR8423878")#exclude sample where log could not be parsed
meta.file = "../sample_info.txt"
alignment.file = "mm10_Bowtie2-FLASH_Bowtie2_alignment_rate.txt"
boxplot.file = "mm10_Bowtie2-FLASH_Bowtie2_alignment_rate.png"

#exclude.samples = c("SRR8423878")#exclude sample where metadata is not  defined
#meta.file = "../sample_info.txt"
#alignment.file = "mm10_Bowtie2-PEAR_Bowtie2_alignment_rate.txt"
#boxplot.file = "mm10_Bowtie2-PEAR_Bowtie2_alignment_rate.png"




meta.table = read.table(meta.file, head=T, sep="\t")
alignment.table = read.table(alignment.file, head=T, sep="\t")
print(dim(alignment.table))
alignment.table = alignment.table[-match(exclude.samples,alignment.table$Sample),]
print(dim(alignment.table))

sequencer =  meta.table$Sequencer[match(alignment.table$Sample,meta.table$Sample)]
amplicon =  meta.table$Amplicon[match(alignment.table$Sample,meta.table$Sample)]

Group = as.factor(paste(sequencer," - ",amplicon,sep=""))

group.colors = c("green","blue","orange","red")

png(boxplot.file)
par(mar=c(3,5,7,2))
plot(Group, alignment.table$Alignment.Rate,
	xlab="Sequencer - Amplicon", ylab="Bowtie2 Local Alignment Rate", 
	xaxt = "n", col=group.colors, outline=FALSE)
points(jitter(as.numeric(Group)),alignment.table$Alignment.Rate, pch=16)
mtext("Sequencer - Amplicon",side=1, line=1.5)
legend("top", levels(Group),col=group.colors,
	inset=-0.15, xpd=T, pch=15, ncol=2, cex=0.9)
dev.off()