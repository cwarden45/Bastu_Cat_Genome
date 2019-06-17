I first checked whether I could find PhiX reads in my sample, but there were 0 PhiX-aligned reads in this sample (using `Bowtie2_alignment_PE.sh`).  Perhaps this shouldn't be surprising, since I would guess these are dual-barcoded samples, and the PhiX spike-in doesn't have a barcode (for example, there was one sample where I could [reduce the number of PhiX reads from over 1 million to a couple dozen by using a 2nd barcode that was different](https://www.biostars.org/p/376585/#380738), because the PhiX samples should kind of be thought of like the single-barcode samples when processed as dual-barcode samples).  However, that same section of the Biostars discussion describe an eDNA diversity paper, where PhiX sequences were *more* prevalent in the NovaSeq SRA data than the MiSeq SRA data.

I also ran [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) on the FASTQ files.

One thing that I thought may be interesting was the adapter distribution, which you can see here for the forward (R1) read:

![R1 adapter content](FastQC_adapter_content_R1.png "R1 adapter content")

and here for the reverse (R2) read:

![R2 adapter content](FastQC_adapter_content_R1.png "R2 adapter content")

Namely, the Nextera adapter can be found in quite a number of reads.  So, I think the fragment size is less than 150 bp for a non-trivial number of reads (the forward and reverse reads are 150 bp each).

I haven't had a chance to look into this more, but I will add code and results if I think there is something valueable in the flanking sequence that doesn't actually come from the cat genome.
