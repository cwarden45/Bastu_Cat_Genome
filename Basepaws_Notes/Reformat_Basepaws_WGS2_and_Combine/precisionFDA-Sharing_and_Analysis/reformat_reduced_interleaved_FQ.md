This code is intended to convert an interleaved format provided by Basepaws to a more common paired-end format with separate forward (R1) and reverse (R2) reads.

For more details, please see [here](https://github.com/cwarden45/Bastu_Cat_Genome/tree/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine) or [here](http://cdwscience.blogspot.com/2022/12/metagenomics-classifications-across.html).

To copy content from the first link, here is the input file structure that we want to change (shown for a pair of reads):

```
@1 1
GNCTTCTAAACCATCAGCTTGCTTGCCCTCAAATTCCTGTAGTAAGTTTACTTAGGGTTTAGCCTGGGGTGGGAGGTGATGAGAGGGACCTCTGTTCATCCCCTTCCTTGCTTCCATCATGTCCCTGATTAGACCACCTTCCCTCCAGCAC
+
F!:FFFF,FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFF:FFFFF:FFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFFFFFFFFFFFFFF:FFFFFFFF:FFFFFFFFFFFFFFFFFFFFF
@1 2
GGTCTGCCCAAGGAGCCAAAGGGCCAGTTCCATCAGAAGACAGACACTGTTAGGGGCACGGAGAGAGAGGGCAGAAATCTTCATCCATAAACTATCTACGAAAATATCGGGCTCCAACTTTTTATCCTTTCACTGAAGTATCTGTTAGCAA
+
FF::FFFFFFFFF,F::FFFFFFFFFF,,FFFFFFFFFFFFFFFF:F:FF::F:FFFF:FFFF:FFFFFFFFFFFFFFFFFFFFFF:FFFFFFFFFF::FF,FFFFFFFF:FFFFFFF:F,F,F:F:,F,F:FFFFFFFFFF:FFFFF:FF

```

I was provided spearate files per lane and run.  **So, you can see this would cause a problem if I tried to use the existing names when concatinating the reformatted reads.**

Thus, the goal of the script is to create separate R1 and R2 reads **while also providing names for individual reads that will be unique in a concatinated file**.

## Input Values

`Source ID` = Names to add to individual reads that will be unique when concatinated.  I used part of the input file name for this.

`Interleaved Input` = A single interleaved file (as compressed `.fastq.gz`).

I received raw Whole Genome Sequencing data in different formats for each of my 2 samples from Basepaws.  However, this script is for the later samples (from 2022).  In theory, this could also work if a similar strategy was used by any other companies/organizations.

**Please note that the code is written with an assumption that the input and output are compressed.**  The script will not work properly if the files are uncompressed.

## Output Values

`Forward (R1) Output Read` = Output file for separate forward reads (as compressed `.fastq.gz`).

`Reverse (R2) Output Read` = Output file for separate reverse reads (as compressed `.fastq.gz`).

**Please note that the code is written with an assumption that the input and output are compressed.**  The script will not work as expected if you specify uncompressed output file names.