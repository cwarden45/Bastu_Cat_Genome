Bracken_file_IN = "Kraken2_Bracken/HCWGS0003.23.HCWGS0003_Kraken2_bracken.kreport"
Bracken_file_OUT = "Kraken2_Bracken/HCWGS0003.23.HCWGS0003_Kraken2_bracken.kreport-ANNOTATED.txt"
Bracken_file_TEST = "Kraken2_Bracken/HCWGS0003.23.HCWGS0003_Kraken2_bracken.kreport-TESTING.txt"

basepaws_file = "Kao_et_al_2021v1-SuppTable1.txt"

basepaws_table = read.table(basepaws_file, head=T, sep="\t")
Braken_table = read.table(Bracken_file_IN, head=F, sep="\t")

names(Braken_table)=c("Percent","Fragments_clade","Fragments_direct","Taxonomic_Rank","NCBI_Taxonomy_ID","Scientific_Name")

##doesn't match 100%?
match_arr = match(basepaws_table$Taxonomy.ID, Braken_table$NCBI_Taxonomy_ID)
basepaws_check_table = Braken_table[match_arr,]

unmapped_table = basepaws_table[is.na(match_arr),]

names(basepaws_table) = paste("basepaws.",names(basepaws_table),sep="")

write.table(data.frame(basepaws_check_table, basepaws_table), Bracken_file_TEST, quote=F, sep="\t", row.names=F)


