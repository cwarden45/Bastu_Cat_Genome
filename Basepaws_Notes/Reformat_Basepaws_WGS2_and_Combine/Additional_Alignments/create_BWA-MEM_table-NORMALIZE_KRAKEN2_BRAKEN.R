input_folder = "BWA-MEM_Human-hg19_Cat-felCat9-Bacteria11_Alignment"
input_reference_counts = "../n29_FILTERED_Braken_genera-counts.txt"
Species   = c("Cat" ,"Cat" ,"Human","Human","Human","Human")
SampleSite= c("Oral","Oral","Oral" ,"Oral" ,"Oral" ,"Oral")
output.percent_quantified = "n6_Oral_BWA-MEM-heatmap_quantified.txt"
output.counts = "n6_Oral_BWA-MEM-counts_raw.txt"
output.percent = "n6_Oral_BWA-MEM-percent-external_normalized.txt"
heatmap.output = "n6_Oral_BWA-MEM-heatmap.pdf"

idxstats_files = list.files(input_folder,"_idxstats.txt")
for (i in 1:length(idxstats_files)){
	sampleID = gsub("_idxstats.txt","",idxstats_files[i])
	print(sampleID)
	idxstats_table = read.table(paste(input_folder,idxstats_files[i],sep="/"), head=F, sep="\t")
	print(dim(idxstats_table))
	idxstats_table = idxstats_table[(nrow(idxstats_table)-11):(nrow(idxstats_table)-1),]
	print(dim(idxstats_table))
	
	sample_counts = (idxstats_table$V3-idxstats_table$V4)/2
	sample_counts[sample_counts < 0]=0
	
	if (i==1){
		count_table = data.frame(Genus=as.character(idxstats_table$V1), sampleID=sample_counts)
		colnames(count_table)[i+1]=sampleID
		print(dim(count_table))
	}else{
		count_table = data.frame(count_table, sampleID=sample_counts)
		colnames(count_table)[i+1]=sampleID
		print(dim(count_table))
	}#end else
	#print(tail(percent_quantified_table))
}#end for (i in 1:length(idxstats_files))

write.table(count_table, output.counts, quote=F, sep="\t", row.names=F)


non_host.count_table = read.table(input_reference_counts, head=T, sep="\t")
non_host.counts = apply(non_host.count_table[,2:ncol(non_host.count_table)], 2, sum)

non_host.counts = non_host.counts[match(names(count_table)[2:ncol(count_table)], names(non_host.counts))]

genus_percent.normalize_external=count_table
for (i in 2:ncol(genus_percent.normalize_external)){
	genus_percent.normalize_external[,i] = round(100 * count_table[,i]/non_host.counts[i-1], digits=4)
}#end for (i in 2:ncol(genus_percent.normalize_external))

write.table(genus_percent.normalize_external, output.percent, quote=F, sep="\t", row.names=F)

#based largely on https://github.com/cwarden45/DTC_Scripts/blob/master/Psomagen_Viome/mothur_analysis/mothur_genera_clustering.R
#uses R v3.6.3 and gplots v3.1.1
library(gplots)

genus_percent = genus_percent.normalize_external[,2:ncol(genus_percent.normalize_external)]
rownames(genus_percent)=genus_percent.normalize_external$Genus

speciesCol=rep("black",length(Species))
speciesCol[Species == "Cat"]=rainbow(4)[1]
speciesCol[Species == "Human"]=rainbow(4)[2]

siteCol=rep("black",length(Species))
siteCol[SampleSite == "Oral"]=rainbow(4)[3]
siteCol[SampleSite == "Fecal"]=rainbow(4)[4]

source("../heatmap.3.R")

column_annotation = as.matrix(data.frame(Species = speciesCol,SampleSite = siteCol))
colnames(column_annotation)=c("Species","SampleSite")

#copied from https://github.com/cwarden45/RNAseq_templates/blob/master/TopHat_Workflow/DEG_goseq.R
cor.dist = function(mat){
	cor.mat = cor(as.matrix(t(mat)))
	dis.mat = 1 - cor.mat
	return(as.dist(dis.mat))	
}#end def cor.dist

pdf(heatmap.output)
#Pearson Dissimilarity looks good - however, don't cluster in order to more easily compare to Bowtie2 heatmap
heatmap.3(genus_percent,   distfun = cor.dist, hclustfun = hclust,
			#dendrogram="both",
			dendrogram="none", Rowv =F, Colv = F,
			col=colorpanel(33, low="black", mid="pink", high="red"), density.info="none", key=TRUE,
			ColSideColors=column_annotation, ColSideColorsSize=2, cexRow=1, cexCol=1.4,
			trace="none", margins = c(18,15))
legend("topright", pch=15, ncol=1, pt.cex=0.75, cex=0.75,
		legend=c("Fecal","Oral","","Human","Cat"),
		col=c(rainbow(4)[4],rainbow(4)[3],"white",rainbow(4)[2],rainbow(4)[1]))
dev.off()