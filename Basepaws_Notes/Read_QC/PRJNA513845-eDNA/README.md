This is not analysis of Bastu's WGS data, and instead this relates to [this post-publication discussion](https://www.nature.com/articles/s41598-019-42455-9#article-comments).

However, you might be able to define the common goal as troubleshooting possible barcode issues from read analysis.  If you can successfully separate cross-contamination, THEN this could also relate to metagenomics analysis of remaining reads for the cat and human WGS data.

I am not entirely sure why my code is not identifying any barcodes (especially for the MiSeq samples), but I started to look at 1 example.

For example, here are the 1st 3 paired-end reads for SRR8423864:

```
>R1
ACTTTACTTGATTTTTGGTGGGTTATCAGGAGTTTTGGGTACTACTATGTCTGTGCTTATTCGTCTTCAATTAGCTAGTCCTGGCAACGATTTTTTAGGCGGTAATCATCAACTATATAATGTTATTGTTACAGCTCATGCCTTTTTAATGATTTTTTTTATGGTTATGCCAGTTCTTATAGGATGCTTTTGTAACTGGTTATTTCCACTTATTATTGGTGCACCTGATATT
>R2
CATATCATGTTCTCCAATCATAAGTGTTACTATCCAGTTACCAATTCCTCCTATAAGTACTGGCATAACCATAAAAAAAATCATTAAAAATGCATGAGCTGTAACAATAACATTATATAGTTGATGATTACCGCCTAAAAAATCGTTTCCAGGACTAGCTAATTTACTACGAATAAGCACAGACATAGTAGTACCCAAAACTCCTGATAACCCACCAAACATCAAGTAAAGTTTGCCCATGTCTTTCTTCTTAGT
>R2_revcom
ACTAAGAAGAAAGACATGGGCAAACTTTACTTGATGTTTGGTGGGTTATCAGGAGTTTTGGGTACTACTATGTCTGTGCTTATTCGTAGTAAATTAGCTAGTCCTGGAAACGATTTTTTAGGCGGTAATCATCAACTATATAATGTTATTGTTACAGCTCATGCATTTTTAATGATTTTTTTTATGGTTATGCCAGTACTTATAGGAGGAATTGGTAACTGGATAGTAACACTTATGATTGGAGAACATGATATG

>R1
ACTTTACTTGATTTTTGGTGGGTTATCAGGAGTTTTGGGTACTACTATGTCTGTGCTTATTCGTCTTCAATTAGCTAGTCCTGGCAACGATTTTTTAGGCGGTAATCATCAACTATATAATGTTATTGTTACAGCTCATGCCTTTTTAATGATTTTTTTTATGGTTATGCCAGTTCTTATAGGATGCTTTGGTAACTGGTTAGTTCCCCTTATTATTGGTTCCCCTGTTATG
>R2
CCTATCCTGTGCTCCAATCATAAGTGTTACTAACCAGTTTCCAAAGCCTCCTATAAGTACTTGCATAACCATTATTAATATCATTAAAAATGCATGAGCTGTAACAATTACATTTTATAGTTGATTATTACCTCCTAACAAATCGTTTCCAGGACTAGCTATTTTAAGACGAATAATCTCACACATAGTAGTACCCAAAACTCCTGTTAACCCACCAAAAATCAAGTAAAGT
>R2_revcom
ACTTTACTTGATTTTTGGTGGGTTAACAGGAGTTTTGGGTACTACTATGTGTGAGATTATTCGTCTTAAAATAGCTAGTCCTGGAAACGATTTGTTAGGAGGTAATAATCAACTATAAAATGTAATTGTTACAGCTCATGCATTTTTAATGATATTAATAATGGTTATGCAAGTACTTATAGGAGGCTTTGGAAACTGGTTAGTAACACTTATGATTGGAGCACAGGATAGG

>R1
TTTATATTTAATTTTTGGTGCTATTTCAGGTGTTGCAGGAACAGCATTATCTTTATACATTAGAATCACACTAGCGCAACCTAACAGTAGTTTCTTAGAATATAACCATCATTTATACAATGTTTTTGTAACAGGTCTTTCTTTTATTATGATTTTTTTTATGGTACTGCCTACATTAATTGGTGGTTTCTGCAACTGGTTTTTTCCGTTATTTATTGGTGCACCTGATATT
>R2
CATATCAGGTGCACCGATCATAATTGGGACAAACCAATTACCAAATCCACCAATCATTGCAGGCATTACCATGAAGAAAATCATTATTAATCCATGGCCTGTAACCAACACATTATATAAGTGATAGTTGCCACCTAAAATTCCATCACCAGGATGCATCAATTCAATTCTCATTAATACTGAAAAAGCTGTACCAATAATTCCTGCAACAATTGCAAAAATTAAATACATT
>R2_revcom
AATGTATTTAATTTTTGCAATTGTTGCAGGAATTATTGGTACAGCTTTTTCAGTATTAATGAGAATTGAATTGATGCATCCTGGTGATGGAATTTTAGGTGGCAACTATCACTTATATAATGTGTTGGTTACAGGCCATGGATTAATAATGATTTTCTTCATGGTAATGCCTGCAATGATTGGTGGATTTGGTAATTGGTTTGTCCCAATTATGATCGGTGCACCTGATATG
```

Raw reads from the Illumina sequencers should have the **same length** (if they all come from the same run, and no post-processing filters are applied), but you can see length variation in the above sequences as well as this FastQC summary for the forward read:

![FastQC Length Distribution](sequence_length_distribution.png "FastQC Length Distribution")

I can see how the forward primer for the F230 amplicon (with reference to [Gibson et al. 2015](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0138432)) matches the beginning of COI reference sequence [MT433998.1](https://www.ncbi.nlm.nih.gov/nucleotide/MT433998.1), starting after the underlined sequence in the [Singer et al. 2019 paper](https://www.nature.com/articles/s41598-019-42455-9).

Likewise, if I look for the reverse complement of the shared reverse primer (after the underlined sequence in the paper, or in the PLOS ONE paper: TT[C/T]CC[?]CG[?]ATAAA[C/T]AA[C/T]ATAAG), it looks like TTCCCTCGAATAAATAACATGAG is the sequence from the [MT433998.1](https://www.ncbi.nlm.nih.gov/nucleotide/MT433998.1) reference.

[Table 1](https://www.nature.com/articles/srep15894/tables/1) from the referenced [Shokralla et al. 2015](https://www.nature.com/articles/srep15894) paper also provides the forward and shared reverse primer for the Mini_SH-E amplicon.  The paper describes that as a shorter fragment, and it looks like the Clustal Omega for the other forward primer is shifted by 5 bp in the reference sequence (ACAAATCATAAAGATATTGGCAC).  For that given reference sequence, my understanding is that this can be thought of as a visualization of the amplicon:

```
CLUSTAL O(1.2.4) multiple sequence alignment


Common_R               ------------------------------------------------------------	0
Mini_SH-E_F            -----ACAAATCATAAAGATATTGGCAC--------------------------------	23
MT433998.1_target      GGTCAACAAATCATAAAGATATTGGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAA	60
F230_F                 GGTCAACAAATCATAAAGATATTGG-----------------------------------	25
                                                                                   

Common_R               ------------------------------------------------------------	0
Mini_SH-E_F            ------------------------------------------------------------	23
MT433998.1_target      TAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCC	120
F230_F                 ------------------------------------------------------------	25
                                                                                   

Common_R               ------------------------------------------------------------	0
Mini_SH-E_F            ------------------------------------------------------------	23
MT433998.1_target      TCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCT	180
F230_F                 ------------------------------------------------------------	25
                                                                                   

Common_R               ------------------------------------------------------------	0
Mini_SH-E_F            ------------------------------------------------------------	23
MT433998.1_target      TTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTG	240
F230_F                 ------------------------------------------------------------	25
                                                                                   

Common_R               -----------------TTCCCTCGAATAAATAACATGAG	23
Mini_SH-E_F            ----------------------------------------	23
MT433998.1_target      GTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAG	280
F230_F                 ----------------------------------------	25
```

For convenience, this is the reference sequence (for 1 species) that I believe that can compared:

```
>MT433998.1_target
GGTCAACAAATCATAAAGATATTGGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAATAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAAGCCAGCCCGGCTCTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAATTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAATGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAG
```

This allows me to run the following comparison for that 1st set of paired reads:

```
CLUSTAL O(1.2.4) multiple sequence alignment


Common_R               ------------------------------------------------------------	0
MT433998.1_target      GGTCAACAAATCATAAAGATATTGGCACCCTCTATCTAGTATTTGGTGCTTGAGCCGGAA	60
Mini_SH-E_F            -----ACAAATCATAAAGATATTGGCAC--------------------------------	23
R1                     ----------------------------ACTTTACTTGATTTTTGGTGGGTTATCAGGAG	32
R2_revcom              -----ACTAAGAAGAAAGACATGGGCAAACTTTACTTGATGTTTGGTGGGTTATCAGGAG	55
                                                                                   

Common_R               ------------------------------------------------------------	0
MT433998.1_target      TAGTAGGAACTGCATTAAGCCTCCTAATTCGGGCAGAACTAA------GCCAGCCCGGCT	114
Mini_SH-E_F            ------------------------------------------------------------	23
R1                     TTTTGGGTACTACTATGTCTGTGCTTATTCGTCTTCAATTAGCTAGTCCTGGCAACGATT	92
R2_revcom              TTTTGGGTACTACTATGTCTGTGCTTATTCGTAGTAAATTAGCTAGTCCTGGAAACGATT	115
                                                                                   

Common_R               ------------------------------------------------------------	0
MT433998.1_target      CTCTCCTCGGAGACGACCAGATTTATAATGTAATTGTTACAGCACATGCTTTCGTAATAA	174
Mini_SH-E_F            ------------------------------------------------------------	23
R1                     TTTTAGGCGGTAATCATCAACTATATAATGTTATTGTTACAGCTCATGCCTTTTTAATGA	152
R2_revcom              TTTTAGGCGGTAATCATCAACTATATAATGTTATTGTTACAGCTCATGCATTTTTAATGA	175
                                                                                   

Common_R               ------------------------------------------------------------	0
MT433998.1_target      TTTTCTTTATAGTAATGCCAATTATAATTGGAGGTTTTGGAAACTGACTAGTGCCACTAA	234
Mini_SH-E_F            ------------------------------------------------------------	23
R1                     TTTTTTTTATGGTTATGCCAGTTCTTATAGGATGCTTTTGTAACTGGTTATTTCCACTTA	212
R2_revcom              TTTTTTTTATGGTTATGCCAGTACTTATAGGAGGAATTGGTAACTGGATAGTAACACTTA	235
                                                                                   

Common_R               -----------------------TTCCCTCGAATAAATAACATGAG	23
MT433998.1_target      TGATTGGTGCACCAGACATGGCCTTCCCTCGAATAAATAACATGAG	280
Mini_SH-E_F            ----------------------------------------------	23
R1                     TTATTGGTGCACCTGATATT--------------------------	232
R2_revcom              TGATTGGAGAACATGATATG--------------------------	255                     
```

There are still differences between the forward and reverse read, but this makes it look like the primers should be either right next to the sequence (for the Mini_SH-E_F primer) or a little outside the sequence (for the common reverse sequence).  However, it looks like the `ACTAAGAAGAAAGACATGGGCAA` sequenced on the reverse complement of the R2 read is the non-degenerate primer sequence match for this sample.

There is also an NCBI Gene listing for [COX1](https://www.ncbi.nlm.nih.gov/gene/22164940) in *Oreochromis niloticus x Oreochromis aureus*, with a gene annotation in [NC_025669.1](https://www.ncbi.nlm.nih.gov/nuccore/NC_025669.1).
