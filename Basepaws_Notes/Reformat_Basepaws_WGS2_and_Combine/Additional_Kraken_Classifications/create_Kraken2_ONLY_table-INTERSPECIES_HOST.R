#input_folder = "../Kraken-OUT"
#Species   = c("Cat" ,"Cat" ,"Human","Human","Human","Human","Human","Human","Human","Cat"  ,"Cat"  ,"Cat"  ,"Cat"  ,"Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human")
#SampleSite= c("Oral","Oral","Oral" ,"Fecal","Fecal","Fecal","Oral" ,"Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Oral" ,"Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Oral" ,"Oral" ,"Oral")
#output.classification_rate = "n29_Kraken2-Bacterial_Classifications.txt"
#output.percent_quantified = "n29_FILTERED_Kraken2_genera-heatmap_quantified.txt"
#output.counts = "n29_FILTERED_Kraken2_genera-counts.txt"
#heatmap.output_quantified = "n29_FILTERED_Kraken2_genera-heatmap_quantified.png"
#heatmap.output_quantified20 = "n29_FILTERED_Kraken2_genera-heatmap_quantified-TOP20.png"
#min.percent = 0.5

input_folder = "Kraken-OUT-k2_standard_20221209-DOWNSAMPLE_1M"
Species   = c("Cat" ,"Cat" ,"Human","Human","Human","Human","Human","Human","Human","Cat"  ,"Cat"  ,"Cat"  ,"Cat"  ,"Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human","Human")
SampleSite= c("Oral","Oral","Oral" ,"Fecal","Fecal","Fecal","Oral" ,"Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Oral" ,"Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Fecal","Oral" ,"Oral" ,"Oral")
output.classification_rate = "n29_k2_standard_20221209-Kraken2-Bacterial_Classifications-DOWNSAMPLE.txt"
output.percent_quantified = "n29_k2_standard_20221209-FILTERED_Kraken2_genera-heatmap_quantified-DOWNSAMPLE.txt"
output.counts = "n29_k2_standard_20221209-FILTERED_Kraken2_genera-counts-DOWNSAMPLE.txt"
heatmap.output_quantified = "n29_k2_standard_20221209-FILTERED_Kraken2_genera-heatmap_quantified-DOWNSAMPLE.png"
heatmap.output_quantified20 = "n29_k2_standard_20221209-FILTERED_Kraken2_genera-heatmap_quantified-TOP20-DOWNSAMPLE.png"
min.percent = 0.5

classification.rate = c()
Kraken2_files = list.files(input_folder,"_Kraken2.kreport")
for (i in 1:length(Kraken2_files)){
	Kraken2_table = read.table(paste(input_folder,Kraken2_files[i],sep="/"), head=F, sep="\t")
	classification.rate[i]=Kraken2_table$V1[Kraken2_table$V6 == "    Bacteria"]
}#end for (i in 1:length(Kraken2_files))

classification.table = data.frame(Sample=gsub("_Kraken2.kreport","",Kraken2_files),Classification_Rate=classification.rate)
write.table(classification.table, output.classification_rate, quote=F, sep="\t", row.names=F)

for (i in 1:length(Kraken2_files)){
	sampleID = gsub("_Kraken2.kreport","",Kraken2_files[i])
	print(sampleID)
	Kraken2_table = read.table(paste(input_folder,Kraken2_files[i],sep="/"), head=F, sep="\t")
	Kraken2_table$V6 = gsub("\\s+","",as.character(Kraken2_table$V6))
	print(dim(Kraken2_table))##MODIIFED CODE
	Eukaryota_index = grep("^Eukaryota$",Kraken2_table$V6)#MODIFIED CODE
	Bacteria_index = grep("^Bacteria$",Kraken2_table$V6)#MODIFIED CODE
	if(length(Eukaryota_index) == 1){
		if(length(Bacteria_index) == 1){
			if(Bacteria_index > Eukaryota_index){
				keep_rows = Bacteria_index:nrow(Kraken2_table)#MODIFIED CODE
				
				Kraken2_table=Kraken2_table[keep_rows,]#MODIFIED CODE
			}else{
				keep_rows = 1:(Eukaryota_index-1)#MODIFIED CODE
				Viral_index = grep("^Viruses$",Kraken2_table$V6)#MODIFIED CODE
				if(length(Viral_index) == 1){
					if(Viral_index > Eukaryota_index){
						keep_rows = c(keep_rows,Viral_index:nrow(Kraken2_table))#MODIFIED CODE
					}#end if(Viral_index > Eukaryota_index) ..MODIFIED CODE	
				}else if(length(Viral_index) > 1){
					print("Troubleshoot code with more than one Viral row")#MODIFIED CODE
					print(Viral_index)#MODIFIED CODE
					print(Kraken2_table$V6[Viral_index])#MODIFIED CODE
					stop()#MODIFIED CODE
				}#end 	
				Kraken2_table=Kraken2_table[keep_rows,]#MODIFIED CODE
			}#end else...MODIFIED CODE	
		}else{
			print("Troubleshoot code with more than one Bacteria row")#MODIFIED CODE
			print(Bacteria_index)#MODIFIED CODE
			print(Kraken2_table$V6[Bacteria_index])#MODIFIED CODE
			stop()#MODIFIED CODE
		}#end else...MODIFIED CODE
	}else if(length(Eukaryota_index) > 1){
		print("Troubleshoot code with more than one Eukaryota row")#MODIFIED CODE
		print(Eukaryota_index)#MODIFIED CODE
		print(Kraken2_table$V6[Eukaryota_index])#MODIFIED CODE
		stop()#MODIFIED CODE
	}#end 

	print(dim(Kraken2_table))##MODIIFED CODE

	Genera_table = Kraken2_table[Kraken2_table$V4 == "G",]
	Genera_table$V6 = gsub("\\s+","",as.character(Genera_table$V6))
	Genera_table = Genera_table[!is.na(Genera_table$V6),]
	Genera_table = Genera_table[Genera_table$V6 != "",]
	sample_genera = gsub("\\s+","",as.character(Genera_table$V6))
	sample_counts = as.numeric(as.character(Genera_table$V2))#MODIFIED CODE
	sample_percent = 100 * sample_counts/sum(sample_counts)#MODIFIED CODE
	
	if (i==1){
		percent_quantified_table = data.frame(Genus=as.character(sample_genera), sampleID=sample_percent)
		colnames(percent_quantified_table)[i+1]=sampleID
		print(dim(percent_quantified_table))
		percent_quantified_table$Genus=as.character(percent_quantified_table$Genus)

		count_table = data.frame(Genus=as.character(sample_genera), sampleID=sample_counts)#MODIFIED CODE
		colnames(count_table)[i+1]=sampleID#MODIFIED CODE
		print(dim(count_table))#MODIFIED CODE
		count_table$Genus=as.character(count_table$Genus)#MODIFIED CODE
	}else{
		prev_genus = as.character(percent_quantified_table$Genus)
		shared_genera = union(prev_genus,sample_genera)
		percent_quantified_table = percent_quantified_table[match(shared_genera,prev_genus),]
		
		percent_quantified_table = data.frame(percent_quantified_table,
												sampleID=sample_percent[match(shared_genera,sample_genera)])
		percent_quantified_table$Genus = as.character(shared_genera)
		colnames(percent_quantified_table)[i+1]=sampleID
		print(dim(percent_quantified_table))
		
		count_table = count_table[match(shared_genera,prev_genus),]#MODIFIED CODE
		
		count_table = data.frame(count_table,
												sampleID=sample_counts[match(shared_genera,sample_genera)])#MODIFIED CODE
		count_table$Genus = as.character(shared_genera)#MODIFIED CODE
		colnames(count_table)[i+1]=sampleID#MODIFIED CODE
		print(dim(count_table))#MODIFIED CODE
	}#end else
	#print(tail(percent_quantified_table))
}#end for (i in 1:length(Kraken2_files))

for (i in 1:length(Kraken2_files)){
	sample_percent = percent_quantified_table[,i+1]
	sample_percent[is.na(sample_percent)]=0
	percent_quantified_table[,i+1]=sample_percent
}#end for (i in 1:length(Kraken2_files))

for (i in 1:length(Kraken2_files)){
	sample_percent = count_table[,i+1]#MODIFIED CODE
	sample_percent[is.na(sample_percent)]=0#MODIFIED CODE
	count_table[,i+1]=sample_percent#MODIFIED CODE
}#end for (i in 1:length(Kraken2_files))#MODIFIED CODE
write.table(count_table, output.counts, quote=F, sep="\t", row.names=F)#MODIFIED CODE

genera_counts = table(percent_quantified_table$Genus)
print(genera_counts[genera_counts != 1])


#based largely on https://github.com/cwarden45/DTC_Scripts/blob/master/Psomagen_Viome/mothur_analysis/mothur_genera_clustering.R
#uses R v3.6.3 and gplots v3.1.1
library(gplots)

genus_percent.quantified = percent_quantified_table[,2:ncol(percent_quantified_table)]
rownames(genus_percent.quantified)=percent_quantified_table$Genus
max_percentage = apply(genus_percent.quantified, 1, max)
genus_percent.quantified = genus_percent.quantified[max_percentage > min.percent,]
print(dim(genus_percent.quantified))

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

png(heatmap.output_quantified, type="cairo")
heatmap.3(genus_percent.quantified,   distfun = cor.dist, hclustfun = hclust,
			col=colorpanel(33, low="black", mid="pink", high="red"), density.info="none", key=TRUE,
			ColSideColors=column_annotation, ColSideColorsSize=2, cexRow=0.5,
			trace="none", margins = c(14,10), dendrogram="both")
legend("topright", pch=15, ncol=1, pt.cex=0.75, cex=0.75,
		legend=c("Fecal","Oral","","Human","Cat"),
		col=c(rainbow(4)[4],rainbow(4)[3],"white",rainbow(4)[2],rainbow(4)[1]))
dev.off()

write.table(data.frame(Genus=rownames(genus_percent.quantified), genus_percent.quantified), output.percent_quantified, quote=F, sep="\t", row.names=F)

genus_percent.quantified2=genus_percent.quantified
print(dim(genus_percent.quantified2))#MODIFIED CODE
average_percent = apply(genus_percent.quantified, 1, mean)#MODIFIED CODE
genus_percent.quantified2=genus_percent.quantified2[order(average_percent, decreasing = TRUE),]#MODIFIED CODE
genus_percent.quantified2=genus_percent.quantified2[1:20,]#MODIFIED CODE
print(dim(genus_percent.quantified2))#MODIFIED CODE

png(heatmap.output_quantified20, type="cairo")
heatmap.3(genus_percent.quantified2,   distfun = cor.dist, hclustfun = hclust,
			col=colorpanel(33, low="black", mid="pink", high="red"), density.info="none", key=TRUE,
			ColSideColors=column_annotation, ColSideColorsSize=2, cexRow=1,
			trace="none", margins = c(14,10), dendrogram="both")
legend("topright", pch=15, ncol=1, pt.cex=0.75, cex=0.75,
		legend=c("Fecal","Oral","","Human","Cat"),
		col=c(rainbow(4)[4],rainbow(4)[3],"white",rainbow(4)[2],rainbow(4)[1]))
dev.off()