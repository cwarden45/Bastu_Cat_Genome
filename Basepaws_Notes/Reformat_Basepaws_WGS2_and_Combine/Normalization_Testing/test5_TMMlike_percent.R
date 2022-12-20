input_reference_counts = "../n29_FILTERED_Braken_genera-counts.txt"
filtered_genera_list="../Additional_Alignments/Bacteria11.bed"
Samples  =   c("Basepaws_WGS1","Basepaws_WGS2","Bristle1","Nebula_lcWGS","SequencingDotCom_WGS","uBiome_Oral2014","uBiome_Oral2019","Veritas_WGS"             )
Species  =   c("Cat"          ,"Cat"          ,"Human"   ,"Human"       ,"Human"               ,"Human"          ,"Human"          ,"Human (Negative Control)")
SampleSite = c("Oral"         ,"Oral"         ,"Oral"    ,"Oral"        ,"Oral"                ,"Oral"           ,"Oral"           ,"Oral"                    )
output.percent_quantified = "test5-n8_Oral_Kraken2_Braken-TMMlike_percent.txt"
dot_plot.output = "test5-n8_Oral_Kraken2_Braken-TMMlike_percent-Staphylococcus.png"
heatmap.output = "test5-n8_Oral_Kraken2_Braken-TMMlike_percent-heatmap_n11.png"

non_host.count_table = read.table(input_reference_counts, head=T, sep="\t")
oral_table = non_host.count_table[,match(Samples,names(non_host.count_table))]
rownames(oral_table)=non_host.count_table$Genus

percent_table=oral_table
for (i in 1:ncol(percent_table)){
	temp_counts = oral_table[,i]
	temp_quantiles = quantile(temp_counts,c(0.3, 0.98))
	temp_quantile_sum = sum(temp_counts[(temp_counts >= temp_quantiles[1])&(temp_counts <= temp_quantiles[2])])
	percent_table[,i] = round(100 * temp_counts/temp_quantile_sum , digits=4)#could be >100%
}#end for (i in 2:ncol(genus_percent.normalize_external))

write.table(data.frame(Genus=rownames(percent_table), percent_table), output.percent_quantified, quote=F, sep="\t", row.names=F)

filtered_genera_bed = read.table(filtered_genera_list, head=F, sep="\t")
filtered_genera = as.character(filtered_genera_bed$V1)
filtered_genera = gsub("_.*$","",filtered_genera)

speciesCol=rep("black",length(Species))
speciesCol[Species == "Cat"]=rainbow(4)[1]
speciesCol[Species == "Human"]=rainbow(4)[2]
speciesCol[Species == "Human (Negative Control)"]="black"

siteCol=rep("black",length(Species))
siteCol[SampleSite == "Oral"]=rainbow(4)[3]
siteCol[SampleSite == "Fecal"]=rainbow(4)[4]

#based on https://github.com/cwarden45/RNAseq_templates/blob/master/TopHat_Workflow/gene_plots.R
png(dot_plot.output, type="cairo")
par(mar=c(15,5,5,2))
plot(as.numeric(as.factor(Samples)), as.numeric(percent_table[rownames(percent_table)=="Streptococcus",]),
		xaxt="n", xlim=c(0,length(Samples)+1),
		xlab="", ylab="TMM-like Percent (Streptococcus)", pch=16, col=speciesCol,
		cex=1.2, main="")
legend("top",c("Cat","Human","Human (Negative Control)"),col=c(rainbow(4)[1],rainbow(4)[2],"black"),
		cex=1.3, pch=16, inset=-0.33, xpd=T, ncol=2)
mtext(Samples, side=1, at =1:length(Samples), las=2, line=2, font=2)
dev.off()

#based largely on https://github.com/cwarden45/DTC_Scripts/blob/master/Psomagen_Viome/mothur_analysis/mothur_genera_clustering.R
#uses R v3.6.3 and gplots v3.1.1
library(gplots)

heatmap.abundance = percent_table[match(filtered_genera, rownames(percent_table)),]

source("../heatmap.3.R")

column_annotation = as.matrix(data.frame(Species = speciesCol,SampleSite = siteCol))
colnames(column_annotation)=c("Species","SampleSite")

#copied from https://github.com/cwarden45/RNAseq_templates/blob/master/TopHat_Workflow/DEG_goseq.R
cor.dist = function(mat){
	cor.mat = cor(as.matrix(t(mat)))
	dis.mat = 1 - cor.mat
	return(as.dist(dis.mat))	
}#end def cor.dist

png(heatmap.output, type="cairo")
#would use Euclidean distance because some samples may all be 0 --> skip because this clustering doesn't look good
heatmap.3(heatmap.abundance,   distfun = dist, hclustfun = hclust,
			dendrogram="none", Rowv =F, Colv = F,
			col=colorpanel(33, low="black", mid="pink", high="red"), density.info="none", key=TRUE,
			ColSideColors=column_annotation, ColSideColorsSize=2, cexRow=1.8, cexCol=1.6,
			trace="none", margins = c(18,15))
legend("topright", pch=15, ncol=1, pt.cex=0.75, cex=0.9,
		legend=c("Fecal","Oral","","Human","Cat"),
		col=c(rainbow(4)[4],rainbow(4)[3],"white",rainbow(4)[2],rainbow(4)[1]))
dev.off()