output.plot = "insert_size_density.png"
xmax=1000
ymax=0.8


insert.files = list.files(".",pattern="*_Picard_insert_stats.txt")
sampleIDs = gsub("_Picard_insert_stats.txt","",insert.files)
lineCol=rainbow(8)[c(3:4,6:8,1)]

png(output.plot, type="cairo")
par(mar=c(5,5,6,2))
for (i in 1:length(insert.files)){
	temp.file = insert.files[i]
	temp.table = read.table(temp.file, skip=10, head=T)
	max_plot_count = sum(temp.table$All_Reads.fr_count[temp.table$insert_size >= xmax])
	plot.table = rbind(temp.table[temp.table$insert_size < xmax,],c(xmax,max_plot_count))
	percentage = 100 * plot.table$All_Reads.fr_count/sum(plot.table$All_Reads.fr_count)

	if(i ==1){
		plot(plot.table$insert_size, percentage,
			xlab="Picard Insert Size",ylab="Percentage of Inserts",
			type="l", col=lineCol[i], lwd=1, ylim=c(0,ymax))
		legend("top", legend=sampleIDs, col=lineCol,lwd=2,
				xpd=T, inset=-0.25, ncol=2)
	}else{
		lines(plot.table$insert_size, percentage,
		col=lineCol[i], lwd=2)
	}
}#end for (i in 1:length(insert.files))
dev.off()