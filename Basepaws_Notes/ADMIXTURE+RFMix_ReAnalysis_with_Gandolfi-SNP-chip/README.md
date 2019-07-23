First, I should thank a basepaws staff member for pointing out that there is genotype data available in the supplemental materials for [Gandolfi et al. 2018](https://www.nature.com/articles/s41598-018-25438-0) (during a discussion at [CatCon](https://www.catconworldwide.com/)).

I don't think the ancestry information is available there, but I will follow-up to see if I either over-looked something (or if I can otherwise obtain that information).

In the meantime, the information in the paper is sufficent for some unsupervised ADMIXTURE analysis.

I've also done some testing of down-sampling markers for the broadest level of human ancestry (which is kind of like the "Eastern" and "Western" cat ancestry), which you can see [here](https://github.com/cwarden45/DTC_Scripts/blob/master/Genes_for_Good/RFMix_ReAnalysis/Downsample_Test/README.md).

I noticed an earlier [basepaws blog post](https://www.basepaws.com/blog/new-basepaws-reports-announcement-136) which looked relatively good (in that the cat was >50% polycat).  However, that is often not what I see in the [Facebook discussion group](https://www.facebook.com/groups/BasepawssadorsCatDNAClub), and I would expect that most cats should be polycats.  Nevertheless, that is the sort of thing that I am trying to look into.

It's a separate project, but there are also pictures of some of the "[trios](http://felinegenetics.missouri.edu/99lives/successfully-sequenced-cats)" from the 99 Lives project, to get an idea about the difference in physical appearance among highly-related but admixed cats.  In other words, I think "appearance" versus "relatedness/kinship" is kind of like "traits" versus "ancestry."

-----------------

**Code Notes**

**0)** Prepare reference FASTA (if needed)

**1)** Prepare gVCF.  I ordered the ~15x sequencing for $1000, so I was provided a gVCF.  However, I believe it was repeat regions were filtered.  So, this caused some issues with matching positions covered by the cat array, and I used `create_GATK_gVCF.sh` (from a [different repository](https://github.com/cwarden45/DTC_Scripts/blob/master/Helix_Mayo_GeneGuide/IBD_Genetic_Distance/create_GATK_gVCF.sh)) to create a gVCF.

**2)** For felCat8, you can reformat the supplemental materials to create a .vcf (with a subset of variants) using `onvert_SupplementaryTable5_to_VCF-and-PED.pl`.

You can also do this for felCat9 using `convert_SupplementaryTable5_to_VCF-and-PED_felCat9.pl`, but you will first need to run `convert_probe_table_to_FASTA.pl` and `create_felCat9_map_from_probe_BLAST.R`.

FYI, there are two different positions provided in Supplementary Table 5 (I believe for felCat6 and felCat8), but I am seeing if there is something available for felCat9 (as well as having a script that maps some extra probes to felCat9).  I noticed the felCat9 lift-over .chain files were only for [felCat5 and felCat8](http://hgdownload.soe.ucsc.edu/goldenPath/felCat9/liftOver/), but I believe there is archived felCat6 data available from NCBI FTP.

**3)** Create a combined VCF (the SNP chip reference panel and your WGS gVCF) using `combine_VCF.pl`.

The code above assumes the felCat8 reference has chromosomes as characters (like "chrA1" but the SNP chip has chromosomes as numbers like "1").  So, you may need to edit the script, and this is probably a good time to provide a warning that ***I unfortuantely won't be able to provided detailed troubleshooting with these scripts*** (although I would be extremely happy if you already had coding experience, and you find hosting this code useful).

**4)** Reformat the combined VCF and run (unsupervised) ADMIXTURE using `plink_ADMIXTURE.sh`.

Even though they both use Ubuntu, I ended up actually running [plink2](http://www.cog-genomics.org/plink/2.0/) within Windows10 (Bash on Ubuntu) and I ran [ADMIXTURE](http://software.genetics.ucla.edu/admixture/download.html) from a Docker image.
