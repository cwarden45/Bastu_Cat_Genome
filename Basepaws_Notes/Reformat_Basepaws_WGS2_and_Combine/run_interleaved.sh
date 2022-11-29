#!/bin/bash

SAMPLEID=Basepaws_WGS2SUB1
INPUTFASTQ=AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS.fastq.gz
OUTPUTFOLDER=Kraken-OUT
REF=/opt/kraken2-2.0.8-beta/data/minikraken_8GB_20200312

### hopefully, only edit code above this point (commenting out sections as needed) ####

KRAKEN=$OUTPUTFOLDER/$SAMPLEID\_Kraken2.kraken
REPORT=$OUTPUTFOLDER/$SAMPLEID\_Kraken2.kreport
/opt/kraken2-2.0.8-beta/build/kraken2 --paired --db $REF --output $KRAKEN --report $REPORT $INPUTFASTQ
#ERROR: I don't think Kraken2 supports this file format:
##Official Kraken2: https://github.com/DerrickWood/kraken2
##Unofficial Kraken2 workflow (with function to work with other format): https://github.com/metashot/kraken2


BRACKEN=$OUTPUTFOLDER/$SAMPLEID\_Kraken2.bracken
/opt/Bracken-2.5/bracken -d $REF -i $REPORT -o $BRACKEN