I first checked whether I could find PhiX reads in my sample, but there were 0 PhiX-aligned reads in this sample (using `Bowtie2_alignment_PE.sh`).  Perhaps this shouldn't be surprising, since I would guess these are dual-barcoded samples, and the PhiX spike-in doesn't have a barcode (for example, there was one sample where I could [reduce the number of PhiX reads from over 1 million to a couple dozen by using a 2nd barcode that was different](https://www.biostars.org/p/376585/#380738), because the PhiX samples should kind of be thought of like the single-barcode samples when processed as dual-barcode samples).  However, that same section of the Biostars discussion describe an eDNA diversity paper, where PhiX sequences were *more* prevalent in the NovaSeq SRA data than the MiSeq SRA data.

I also ran [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) on the FASTQ files.

One thing that I thought may be interesting was the adapter distribution, which you can see here for the forward (R1) read:

![R1 adapter content](FastQC_adapter_content_R1.png "R1 adapter content")

and here for the reverse (R2) read:

![R2 adapter content](FastQC_adapter_content_R1.png "R2 adapter content")

Namely, the Nextera adapter can be found in quite a number of reads.  So, I think the fragment size is less than 150 bp for ~30% of the reads (the forward and reverse reads are 150 bp each).

The insert size calculation comes from the BAM alignment (rather than the FASTQ reads), but I thought it would be better to add here (because it probably is of less interest to most basepaws customers):

![Insert Size Distribution](Provided_BAM_Insert_Size.PNG "Insert Size Distribution")

The insert distribution for the provided .bam file is shown above, but it looks practically the same as the re-aligned .bam file (for example, the mean insert size was 199 bp in the provided .bam and 202 bp in the re-aligned .bam file.

If there is overlap between the forward and reverse reads (for fragments less than 300 bp), you can also make a similar plot without the alignment.  For example, I used [PEAR](https://www.h-its.org/downloads/pear-academic/) to test merging reads (79.717% of reads could be assembled with PEAR), and FastQC to create a plot for the sequence length distribution:

![PEAR Merged Read Length Distribution](PEAR_sequence_length_distribution.png "PEAR Merged Read Length Distribution")

If you are curious what a FASTQ file looks like, here is a screenshot for some of my reads:

![FASTQ example](FASTQ_R1_screenshot.PNG "FASTQ example")

For example, you can tell that this is a dual-barcode libary (where the barcodes for my sample should be AAGGCGA on one end of the fragment, and TAGAGAG at the other end of the fragment).  If you sequence 8 bp for an index, but you only use 7 bp, then that is why there are N's.  You can also see more about the [FASTQ file format](https://en.wikipedia.org/wiki/FASTQ_format) on Wikipedia, and I have a diagram about the [barcoding design](https://www.biostars.org/p/376585/#376623) (based upon what somebody else drew for me) in the Biostars discussion about de-multiplexing.  You can also learn more about the Illumina adapter sequences [here](https://support.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/experiment-design/illumina-adapter-sequences-1000000002694-09.pdf).

Within the read, the "N" nucleotides probably are the result of missing .bcl files.  For some applications, you may want to either filter those reads, or trim certain positions in the read.

If I find anything else that is interesting/informative, I will update this README.
