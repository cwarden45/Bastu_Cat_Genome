#!/bin/bash

ln -s -T /mnt/usb8/Bastu_Cat_Genome/HCWGS0003.23.HCWGS0003_1.fastq.gz Kraken-IN/Basepaws_WGS1_R1.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/HCWGS0003.23.HCWGS0003_2.fastq.gz Kraken-IN/Basepaws_WGS1_R2.fastq.gz

ln -s -T /mnt/usb8/Bastu_Cat_Genome/WGS2/Basepaws_WGS2_R1.fastq.gz Kraken-IN/Basepaws_WGS2_R1.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/WGS2/Basepaws_WGS2_R2.fastq.gz Kraken-IN/Basepaws_WGS2_R2.fastq.gz

ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr4262_9V3V4_R1.fastq.gz Kraken-IN/PetQCheck1_R1.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr4262_9V3V4_R2.fastq.gz Kraken-IN/PetQCheck1_R2.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr4669_1V3V4_R1.fastq.gz Kraken-IN/PetQCheck2_R1.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr4669_1V3V4_R2.fastq.gz Kraken-IN/PetQCheck2_R2.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr5877_3V3V4_R1.fastq.gz Kraken-IN/PetQCheck3_R1.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr5877_3V3V4_R2.fastq.gz Kraken-IN/PetQCheck3_R2.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr8725_3V3V4_R1.fastq.gz Kraken-IN/PetQCheck4_R1.fastq.gz
ln -s -T /mnt/usb8/Bastu_Cat_Genome/PetQCheck/zr8725_3V3V4_R2.fastq.gz Kraken-IN/PetQCheck4_R2.fastq.gz

ln -s -T /mnt/usb8/CDW_Genome/Veritas/veritas_wgs_R1.fastq.gz Kraken-IN/Veritas_WGS_R1.fastq.gz
ln -s -T /mnt/usb8/CDW_Genome/Veritas/veritas_wgs_R2.fastq.gz Kraken-IN/Veritas_WGS_R2.fastq.gz

ln -s -T /mnt/usb8/CDW_Genome/Sequencing.com/CharlesWarden-NG1J8B7TDM-30x-WGS-Sequencing_com-10-13-21.1.fq.gz Kraken-IN/SequencingDotCom_WGS_R1.fastq.gz
ln -s -T /mnt/usb8/CDW_Genome/Sequencing.com/CharlesWarden-NG1J8B7TDM-30x-WGS-Sequencing_com-10-13-21.2.fq.gz Kraken-IN/SequencingDotCom_WGS_R2.fastq.gz

ln -s -T /home/cwarden/CDW_Genome/Nebula/951023c1725b4b52b150c46469121abd_R1.fastq.gz Kraken-IN/Nebula_lcWGS_R1.fastq.gz
ln -s -T /home/cwarden/CDW_Genome/Nebula/951023c1725b4b52b150c46469121abd_R2.fastq.gz Kraken-IN/Nebula_lcWGS_R2.fastq.gz

#as described in https://superuser.com/questions/633605/how-to-create-symbolic-links-to-all-files-class-of-files-in-a-directory
ln -s /mnt/usb8/CDW_Genome/16S_2021/PE150/*.fastq.gz Kraken-IN
ln -s /mnt/usb8/CDW_Genome/16S_2021/PE300/*.fastq.gz Kraken-IN

ln -s -T /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/2019/ssr_1257550_Gut/ssr_1257550__R1__L999.fastq.gz Kraken-IN/uBiome_Fecal2019_R1.fastq.gz
ln -s -T /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/2019/ssr_1257550_Gut/ssr_1257550__R2__L999.fastq.gz Kraken-IN/uBiome_Fecal2019_R2.fastq.gz
ln -s -T /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/2019/ssr_1257789_Mouth/ssr_1257789__R1__L999.fastq.gz Kraken-IN/uBiome_Oral2019_R1.fastq.gz
ln -s -T /mnt/usb8/CDW_Genome/Earlier_16S/uBiome/2019/ssr_1257789_Mouth/ssr_1257789__R2__L999.fastq.gz Kraken-IN/uBiome_Oral2019_R2.fastq.gz