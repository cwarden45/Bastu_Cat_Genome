#setwd("C:\\Users\\Charles\\Documents\\Bastu_Genome\\Cat_SNP_Chip")

input.file = "felCat9_BLAST_output.txt"
output.file = "Gandolfi_felCat9.map"

input.table = read.table(input.file, head=F, sep="\t")

full.probes = unique(input.table$V1)

complement = function(nuc){
	if(nuc == "A"){
		return("T")
	}else if(nuc == "T"){
		return("A")
	}else if(nuc == "G"){
		return("C")
	}else if(nuc == "C"){
		return("G")
	}else{
		print(nuc)
		stop()
	}
}#end def complement

output.chr = c()
output.probeID = c()
output.pos = c()
output.ref = c()
output.alt = c()
output.strand = c()

for (i in 1:length(full.probes)){
	temp.table = input.table[input.table$V1 == full.probes[i],]
	if(nrow(temp.table) == 1){
		#unique probeID
		
		#remind myself how to to R regular expressions from https://github.com/cwarden45/RNAseq_templates/blob/master/TopHat_Workflow/create_sample_description.R
		probe.text = as.character(temp.table$V1)
		#print(probe.text)
		
		reg.obj = gregexpr("\\w$",probe.text)
		ref = unlist(regmatches(probe.text, reg.obj))
		
		probe.text = gsub(paste("_",ref,"$",sep=""),"",probe.text)
		reg.obj = gregexpr("\\w{2}$",probe.text)
		alt = unlist(regmatches(probe.text, reg.obj))
		probe.text = gsub(paste("_",alt,"$",sep=""),"",probe.text)
		alt = gsub(ref,"",alt)
		
		#always 51?
		reg.obj = gregexpr("\\d+$",probe.text)
		probe.pos = unlist(regmatches(probe.text, reg.obj))
		
		if((alt != "DI")&(nchar(alt) == 1)){
			#for ancestry, skip indels
			#also skip result where neither genotype matches the probe sequence
			if(temp.table$V8 > temp.table$V7){
				if(temp.table$V4 == probe.pos){
					genome.pos = temp.table$V8
					
					output.chr = c(output.chr, as.character(temp.table$V5))
					output.probeID = c(output.probeID, gsub(paste("_",probe.pos,"$",sep=""),"",probe.text))
					output.pos = c(output.pos, genome.pos)
					output.ref = c(output.ref, ref)
					output.alt = c(output.alt, alt)
					output.strand =c(output.strand,"+")
				}#end if(temp.table$V4 == probe.pos)
				
				#ignore hits that aren't full length for the probe
			}else{
				#print("Write code for hit on opposite strand")
				if(temp.table$V4 == probe.pos){
					genome.pos = temp.table$V7
					
					output.chr = c(output.chr, as.character(temp.table$V5))
					output.probeID = c(output.probeID, gsub(paste("_",probe.pos,"$",sep=""),"",probe.text))
					output.pos = c(output.pos, genome.pos)
					
					#these should match .vcf, but they won't match genotype table
					output.ref = c(output.ref, complement(ref))
					output.alt = c(output.alt, complement(alt))
					
					#so, add note to reverse complement value in genotype table
					output.strand =c(output.strand,"-")
				}#end if(temp.table$V4 == probe.pos)
				
				#ignore hits that aren't full length for the probe
			}#end else
		}#end if(alt != "DI")
	}#end if(nrow(temp.table) == 1)
}#end for (i in 1:length(full.probes))

#also re-order, since I will be having to write new code anyways)
output.table = data.frame(output.probeID, output.chr, output.pos, output.ref, output.alt, output.strand)

write.table(output.table, output.file, quote=F, sep="\t", row.names=F, col.names=F)

