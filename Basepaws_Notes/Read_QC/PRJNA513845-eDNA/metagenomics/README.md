As noted in [this file](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Read_QC/PRJNA513845-eDNA/extended_summary.xlsx), there are considerable prokaryotic taxonomy assignments from the SRA.  Most commonly, those are for "*Candidatus Pelagibacter ubique*" and "*Candidatus Pelagibacter sp. HIMB1321*", but additional assignments are also made (particuarlly as sequencing depth increases).

So, I have tried to note some different strategies  for metagenomics analysis in order to compare to the SRA (before and after filtering)

**1)** [Kracken2](http://ccb.jhu.edu/software/kraken2/)/[Bracken](https://ccb.jhu.edu/software/bracken/)

*a)* Paired-end FASTQ analysis (for uploaded SRA data) with `run_Kracken2_Bracken-FASTQ-PE.py`
*b)* Single-end FASTQ analysis (for filtered and merged paired-end reads) with `run_Kracken2_Bracken-FASTQ-SE.py`

Either way, this should be followed by `tabulate_Kraken2-Braken_statistics.py`.

The amplicon type (F230 vs FishE) shows a noticabe difference for some metrics (more so than the sequencer).

However, aside from indiciating a non-trivial number of bacterial reads for eukaryotic amplicon sequencing, the classificaiton rate was not as consistently different in a similar way between sequencers.

**Original SRA Downloaded Reads:**

![SRA Kracken2 classification](SRA-downloaded_Kraken2-Bracken_domain_counts.png "SRA Kraken2 classification")

**Cutadapt-Filtered and FLASH-Merged Reads:**

![FLASH Kracken2 classification](FLASH_merged_Kraken2-Bracken_domain_counts.png "FLASH Kraken2 classification")

**Most Kraken2 assignments were bacterial**, so the plots above show the classification rate.  However, the uploaded text files also have the similar bacterial percentages.

I am not sure why the assignment rate drops for the FishE NovaSeq samples.  However, this might not necessarily be good.  For example, if there are more reads from other samples, then the biological origin might not be bacterial (it could be mouse or human, for example).

**2)** [Mash Screen](https://mash.readthedocs.io/en/latest/)

I am focusing on:

*a)* Single-end FASTQ analysis (for filtered and merged paired-end reads) with `run_MashScreen-FASTQ.py`
*b)* Unique sequence FASTA file (should also work for clustered /  corrected unique reads) `run_MashScreen-FASTA.py`

Option *b)* works, but you would have to figure out how to map each individual read for original abundance.  So, I will show the FASTQ result below.

More specifically, I think the taxonomy information would help for interpretation.  These results can still be useful and sometimes capture things not found my Kracken2.

However, for these purposes, I am focusing on the viral reads, as defined as those with "Viral" in the .fna.gz reference name.  Even though I am using the `-w` parameter to try and reduce duplicate hits for what is really the same reference, I am focusing on assignments with more than 1 read below:



**3)** [megablast](https://www.ncbi.nlm.nih.gov/books/NBK279668/) (from [BLAST+](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/)) on unique sequences using `run_megablast-FASTA.sh`

You may want to need to work with a reduced set of sequences (such as OTUs filtered by supporting reads).

**4)** FastQ Screen

**5)** [COI](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Read_QC/PRJNA513845-eDNA/OTU_clustering/COI_ref.fa) reference alignment

For these samples, I am not really primarily interested in the metagenomic assignments.  Instead, I am trying to get a sense of the off-target reads.  So, for that, calculating the unaligned read rate might be helpful for that goal.
