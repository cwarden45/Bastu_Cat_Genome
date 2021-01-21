exclude.samples = c("SRR8423819","SRR8423820","SRR8423822","SRR8423847")#samples not present in alignment folder
meta.file = "../sample_info.txt"
alignment.folder = "mm10_Bowtie2-FLASH"
heatmap.file = "mm10_Bowtie2-FLASH_Bowtie2_alignment_rate_per_chr-V2.pdf"


library(gplots)

meta.table = read.table(meta.file, head=T, sep="\t")
print(dim(meta.table))
meta.table = meta.table[-match(exclude.samples,meta.table$Sample),]
print(dim(meta.table))

meta.table = meta.table[order(meta.table$Amplicon, meta.table$Sequencer),]

sequencer =  meta.table$Sequencer
amplicon =  meta.table$Amplicon

Group = as.factor(paste(sequencer," - ",amplicon,sep=""))

group.colors = c("green","blue","orange","red")

chrs = c(paste("chr",1:19,sep=""), "chrX", "chrY", "chrM")

idxstat_files = paste(alignment.folder,"/",meta.table$Sample,"_idxstats.txt",sep="")

for (i in 1:length(idxstat_files)){
	idxstat_table = read.table(idxstat_files[i], head=F, sep="\t")
	
	total_counts = sum(idxstat_table$V3) + sum(idxstat_table$V4)
	
	temp_percentage = 100 * idxstat_table$V3 / total_counts
	temp_percentage = temp_percentage[match(chrs,idxstat_table$V1)]
	
	if(i == 1){
		percent_mat = temp_percentage
		names(percent_mat)=chrs
	}else{
		temp_mat = temp_percentage
		names(temp_mat)=chrs

		percent_mat = rbind(percent_mat,temp_mat)
	}#end else
}#end for (i in 1:length(idxstat_files))

rownames(percent_mat) = meta.table$Sample


colGroup = rep("black",length(meta.table$Sample))
groups = levels(Group)
for(i in 1:length(groups)){
	colGroup[Group == groups[i]]=group.colors[i]
}#end for(i in 1:length(groups))


pdf(heatmap.file)
heatmap.2(percent_mat, Rowv=FALSE, Colv=FALSE, dendrogram = "none",
			col=colorpanel(33, low="black", mid="pink", high="red"), density.info="none", key=TRUE,
			trace="none", RowSideColors=colGroup)
legend("topright", groups,col=group.colors,
	inset=0, xpd=T, pch=15, ncol=2, cex=0.8)
dev.off()