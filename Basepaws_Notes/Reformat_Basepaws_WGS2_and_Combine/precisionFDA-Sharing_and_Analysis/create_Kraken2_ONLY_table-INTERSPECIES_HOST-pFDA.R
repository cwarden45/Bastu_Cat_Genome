#sampleIDs = c("Local","pFDA")
#Kraken2_files = c("../Additional_Kraken_Classifications/Kraken-OUT-minikraken_8GB_20200312-10_hit_groups/Veritas_WGS_Kraken2.kreport","report_Veritas-MiniKraken2-MIN_10_HITS.txt")
#output.counts = "VeritasWGS-Kraken2-Local_and_pFDA-counts.txt"
#output.percent_quantified = "VeritasWGS-Kraken2-Local_and_pFDA-percent_quantified.txt"
#correlation_plot = "VeritasWGS-Kraken2-Local_and_pFDA-cor.png"

sampleIDs = c("Local","pFDA")
Kraken2_files = c("../Additional_Kraken_Classifications/Kraken-OUT-minikraken_8GB_20200312-10_hit_groups/Nebula_lcWGS_Kraken2.kreport","report_Nebula_lcWGS-MiniKraken2-MIN_10_HITS.txt")
output.counts = "Nebula_lcWGS-Kraken2-Local_and_pFDA-counts.txt"
output.percent_quantified = "Nebula_lcWGS-Kraken2-Local_and_pFDA-percent_quantified.txt"
correlation_plot = "Nebula_lcWGS-Kraken2-Local_and_pFDA-cor.png"

#copied and modified from https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/Additional_Kraken_Classifications/create_Kraken2_ONLY_table-INTERSPECIES_HOST.R
#This includese pre-existing modified code labels

for (i in 1:length(Kraken2_files)){
	sampleID = sampleIDs[i]
	print(sampleID)
	Kraken2_table = read.table(Kraken2_files[i], head=F, sep="\t")
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

genus_percent.quantified = percent_quantified_table[,2:ncol(percent_quantified_table)]
rownames(genus_percent.quantified)=percent_quantified_table$Genus
write.table(data.frame(Genus=rownames(genus_percent.quantified), genus_percent.quantified), output.percent_quantified, quote=F, sep="\t", row.names=F)

png(correlation_plot, type="cairo", height=400, width=800)
par(mfcol=c(1,2))
plot(genus_percent.quantified$Local, genus_percent.quantified$pFDA,
		pch=16, xlab="Local MiniKraken2 (Min 10 Hits)", ylab="precisionFDA (Min 10 Hits)",
		main = paste("Linear Correlation (r = ",signif(cor(genus_percent.quantified$Local, genus_percent.quantified$pFDA), digits=2),")",sep=""),
		xlim=c(0,25),ylim=c(0,25))
abline(a=0, b=1, col="gray")
#abline(lm(genus_percent.quantified$pFDA~genus_percent.quantified$Local), col="blue")

plot(log2(genus_percent.quantified$Local+0.5), log2(genus_percent.quantified$pFDA+0.5),
		pch=16, xlab="Local MiniKraken2 (Min 10 Hits)", ylab="precisionFDA (Min 10 Hits)",
		main = paste("Log2(Percent + 0.5) Correlation (r = ",signif(cor(log2(genus_percent.quantified$Local+0.5), log2(genus_percent.quantified$pFDA+0.5)), digits=2),")",sep=""),
		xlim=c(0,5),ylim=c(0,5))
abline(a=0, b=1, col="gray")
dev.off()