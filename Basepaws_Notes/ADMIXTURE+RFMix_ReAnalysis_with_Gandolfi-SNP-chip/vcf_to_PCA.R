#setwd("E:\\Bastu_Genome\\Cat_SNP_Chip")

cat_of_interest = "Bastu"

vcf = "Gandolfi_felCat8_plus_Bastu.vcf"
ped = "Gandolfi_felCat8_plus_Bastu.ped"
ancestry = "FID_breed_codes_fromHasan.txt"

vcf.table = read.delim(vcf, head=T, sep="\t", comment="")

geno.mat = vcf.table[,10:ncol(vcf.table)]
print(dim(geno.mat))

geno2count = function(value){
	value = as.character(value)
	if(value == "0/0"){
		return(0)
	}else if((value == "0/1")|(value == "1/0")){
		return(1)
	}else if(value == "1/1"){
		return(2)
	}else{
		return(NA)
	}
}#end def geno2count

geno2count_arr = function(arr){
	return(sapply(arr,geno2count))
}#end def geno2count_arr

count.mat = apply(geno.mat,2,geno2count_arr)


ped.table = read.table(ped, head=F, sep="\t")
print(dim(ped.table))

colnames(count.mat)=ped.table$V2

#create ancestry table
ancestry.mapping.table = read.table(ancestry, head=T, sep="\t")

breed = c()
ancestry1 = c()
ancestry2 = c()

for (i in 1:ncol(count.mat)){
	FID = ped.table$V1[i]
	if(FID == cat_of_interest){
		breed = c(breed, cat_of_interest)
		ancestry1 = c(ancestry1, cat_of_interest)
		ancestry2 = c(ancestry2, cat_of_interest)
	}else{
		breed = c(breed, as.character(ancestry.mapping.table$Breed.Name[ancestry.mapping.table$FID == FID]))
		ancestry1 = c(ancestry1, as.character(ancestry.mapping.table$Ancestry1[ancestry.mapping.table$FID == FID]))
		ancestry2 = c(ancestry2, as.character(ancestry.mapping.table$Ancestry2[ancestry.mapping.table$FID == FID]))
	}#end else
}#end for (i in 1:ncol(count.mat))

ancestry.table = data.frame(Cat = colnames(count.mat), breed, ancestry1, ancestry2)

#filter out anything that isn't a domestic cat
print(dim(count.mat))
count.mat = count.mat[,ancestry.table$breed != "European wild cat"]
ancestry.table = ancestry.table[ancestry.table$breed != "European wild cat",]
print(dim(count.mat))
count.mat = count.mat[,ancestry.table$breed != "Asian Leopard Cats"]
ancestry.table = ancestry.table[ancestry.table$breed != "Asian Leopard Cats",]
print(dim(count.mat))
count.mat = count.mat[,ancestry.table$breed != "Big Wild Cat"]
ancestry.table = ancestry.table[ancestry.table$breed != "Big Wild Cat",]
print(dim(count.mat))
count.mat = count.mat[,ancestry.table$breed != "Backcross Ped"]
ancestry.table = ancestry.table[ancestry.table$breed != "Backcross Ped",]
print(dim(count.mat))
count.mat = count.mat[,ancestry.table$breed != "Hydrocephalus (oriental/toygers)"]
ancestry.table = ancestry.table[ancestry.table$breed != "Hydrocephalus (oriental/toygers)",]
print(dim(count.mat))
#seems odd to me, but the two Cinnamon samples are PCA outliers (a lot more inbreeding than normal breeds?)
count.mat = count.mat[,(ancestry.table$Cat != "Cinnamon")&(ancestry.table$Cat != "WGA12682")]
ancestry.table = ancestry.table[(ancestry.table$Cat != "Cinnamon")&(ancestry.table$Cat != "WGA12682"),]
print(dim(count.mat))

#omit NAs for PCA

print(dim(count.mat))
pca.input = na.omit(count.mat)
print(dim(pca.input))

pca.values = prcomp(pca.input)
pc.values = data.frame(pca.values$rotation)
ancestry.table = ancestry.table[match(rownames(pc.values),ancestry.table$Cat),]

#2 ancestry groups
plotCol=rep(adjustcolor( "gray", alpha.f = 0.2),nrow(ancestry.table))
plotCol[ancestry.table$ancestry1 == "Eastern"]="blue"
plotCol[ancestry.table$ancestry1 == "Western"]="orange"

png("PCA_ancestry_2groups.png")
par(mar=c(5,5,3,10))
plot(pc.values$PC1, pc.values$PC2, pch=16, col=plotCol,
	xlab="PC1",ylab="PC2")
points(pc.values$PC1[ancestry.table$ancestry1 == cat_of_interest], pc.values$PC2[ancestry.table$ancestry1 == cat_of_interest], pch=23, cex=2, col="black",bg="red",
	xlab="PC1",ylab="PC2")
legend("right", legend=c("Bastu","","Eastern","Western"),col=c("red","white","blue","orange"),
		pch=16, xpd=T, inset=-0.3)		
dev.off()

#3 ancestry groups
plotCol=rep(adjustcolor( "gray", alpha.f = 0.2),nrow(ancestry.table))
plotCol[ancestry.table$ancestry2 == "Eastern"]="blue"
plotCol[ancestry.table$ancestry2 == "Western"]="orange"
plotCol[ancestry.table$ancestry2 == "Persian"]=adjustcolor( "green", alpha.f = 0.5)

png("PCA_ancestry_3groups.png")
par(mar=c(5,5,3,10))
plot(pc.values$PC1, pc.values$PC2, pch=16, col=plotCol,
	xlab="PC1",ylab="PC2")
points(pc.values$PC1[ancestry.table$ancestry1 == cat_of_interest], pc.values$PC2[ancestry.table$ancestry1 == cat_of_interest], pch=23, cex=2, col="black",bg="red",
	xlab="PC1",ylab="PC2")
legend("right", legend=c("Bastu","","Eastern","Western","Persian"),col=c("red","white","blue","orange","green"),
		pch=16, xpd=T, inset=-0.3)		
dev.off()

#all breeds (color if 20+ samples)
total.ancestry.count =  table(ancestry.table$breed)
plot.ancestry = names(total.ancestry.count[total.ancestry.count > 20])

plotCol=rep(adjustcolor( "gray", alpha.f = 0.2),nrow(ancestry.table))
breed.colors = rainbow(length(plot.ancestry))
for (i in 1:length(breed.colors)){
	plotCol[ancestry.table$breed == plot.ancestry[i]]=breed.colors[i]
}#end for (i in 1:length(breed.colors))


png("PCA_ancestry_breed_20cats.png")
par(mar=c(5,5,3,10))
plot(pc.values$PC1, pc.values$PC2, pch=16, col=plotCol,
	xlab="PC1",ylab="PC2")
points(pc.values$PC1[ancestry.table$ancestry1 == cat_of_interest], pc.values$PC2[ancestry.table$ancestry1 == cat_of_interest], pch=23, cex=2, col="black",bg="red",
	xlab="PC1",ylab="PC2")
legend("right", legend=c("Bastu","",plot.ancestry),col=c("red","white",breed.colors),
		pch=16, xpd=T, inset=-0.4, cex=0.8)
dev.off()		