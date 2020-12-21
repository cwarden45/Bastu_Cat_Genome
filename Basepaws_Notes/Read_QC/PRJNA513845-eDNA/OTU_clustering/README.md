
**1)** Collect unique sequences into 1 file using `combine_unique_sequences.py`

**2)** Run one of the following OTU clustering methods

*a)* [swarm](https://github.com/torognes/swarm)

The input FASTA file is created using `combine_unique_sequences-multiread-swarm.py`

Swarm is then run using `run_swarm.py`.

This ran successfully and was faster than VSEARCH for the set of sequences present in at least 2 reads for at least 1 sample.  So, I will test Swarm with the full set of reads.


*b)* [vsearch](https://github.com/torognes/vsearch) using `run_vsearch.py`

You can see a legend for the vsearch `--uc` output file [here](https://manpages.debian.org/stretch/vsearch/vsearch.1).


**3)** Create revised count table of counts based upon mapping between clusters and each unique sequence using `create_OTU_count_table-uclust_format.pl` and `create_OTU_count_table-uclust_format-SWARM_MAPPING.pl`

I believe that you can install the full [BioPerl](https://bioperl.org/index.html) dependency by entering a `cpan` shell and running `install Bundle::BioPerl` (as described [here](http://etutorials.org/Programming/perl+bioinformatics/Part+II+Perl+and+Bioinformatics/Chapter+9.+Introduction+to+Bioperl/9.2+Installing+Bioperl/)), and/or `cpanm Bio::Perl` (as described [here](https://stackoverflow.com/questions/47966512/error-installing-xmldomxpath)).  You can also try to run `cpan Bio::SeqIO` or `cpanm Bio::SeqIO` for just this particular script.  I found that I needed to download the .tar.gz file for [XML::DOM::XPath](https://metacpan.org/pod/XML::DOM::XPath) under **Tools --> Download (12.12Kb)** (on the left, towards the middle), and then change the *t/test_non_ascii.t* file to say "*use utf8;*" instead of "use encoding '*utf8';*" (as described in [this discussion](https://stackoverflow.com/questions/47966512/error-installing-xmldomxpath), with complication from source following [these instructions](https://www.thegeekstuff.com/2008/09/how-to-install-perl-modules-manually-and-using-cpan-command/)).

**4)** Similar to the original unique count tables, create summary plots.

For whatever reason, sequences with a larger number of supporing reads (and were between 200 and 300 bp) were excluded in the VSEARCH output file (even with the minimum 2 read for at least 1 sample requirement).  This count information was not provided to VSEARCH (combined between samples).  Nevertheless, something seemed off about the results, possibly because of the exact code and input files being used.  So, I am not showing plots for those results.
