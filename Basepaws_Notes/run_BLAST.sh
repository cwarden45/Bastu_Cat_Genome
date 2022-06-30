#!/bin/bash

#IN=query.fa
#REF=../felCat6_Ref/felCat6.fa
#OUT=felCat6-BLAST_hits.txt

#IN=query.fa
#REF=../felCat8_Ref/felCat8.fa
#OUT=felCat8-BLAST_hits.txt

IN=query.fa
REF=../felCat9.fa
OUT=felCat9-BLAST_hits.txt

/opt/ncbi-blast-2.11.0+/bin/makeblastdb -dbtype nucl -in $REF

#I usually prefer a smaller e-value, but it looks like this was needed for the web-based query
/opt/ncbi-blast-2.11.0+/bin/blastn -evalue 10 -word_size 7 -query $IN -db $REF -out $OUT -outfmt "6 qseqid qstart qend qlen sseqid sstart send slen length nident mismatch gaps pident score"
