#!/bin/bash

gzip -c /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/fecal_131204/ssr_2364__R1__L001.fastq > Kraken-IN/uBiome_Fecal2013_R1.fastq.gz
gzip -c /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/fecal_131204/ssr_2364__R2__L001.fastq > Kraken-IN/uBiome_Fecal2013_R2.fastq.gz

gzip -c /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/fecal_140409/ssr_4530__R1__L001.fastq > Kraken-IN/uBiome_Fecal2014_R1.fastq.gz
gzip -c /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/fecal_140409/ssr_4530__R2__L001.fastq > Kraken-IN/uBiome_Fecal2014_R2.fastq.gz
gzip -c /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/oral_140409/ssr_4534__R1__L001.fastq > Kraken-IN/uBiome_Oral2014_R1.fastq.gz
gzip -c /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/oral_140409/ssr_4534__R2__L001.fastq > Kraken-IN/uBiome_Oral2014_R2.fastq.gz