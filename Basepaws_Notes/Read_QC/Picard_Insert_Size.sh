#!/bin/bash

#PREFIX=HCWGS0003.23.HCWGS0003
PREFIX=felCat9.gatk

java -jar /opt/picard-tools-2.5.0/picard.jar CollectInsertSizeMetrics \
      I=$PREFIX.bam \
      O=$PREFIX\_insert_size_metrics.txt \
      H=$PREFIX\_insert_size_histogram.pdf