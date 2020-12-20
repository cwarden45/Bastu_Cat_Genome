
**1)** Collect unique sequences into 1 file using `combine_unique_sequences.py`

**2)** Run one of the following OTU clustering methods

*a)* [swarm](https://github.com/torognes/swarm)

The input FASTA file is created using `combine_unique_sequences-multiread-swarm.py`

Swarm is then run using `run_swarm.py`.

This ran successfully and was faster than VSEARCH for the set of sequences present in at least 2 reads for at least 1 sample.  So, I will test Swarm with the full set of reads.


*b)* [vsearch](https://github.com/torognes/vsearch) using `run_vsearch.py`

You can see a legend for the vsearch `--uc` output file [here](https://manpages.debian.org/stretch/vsearch/vsearch.1).


**3)** Create revised count table of counts based upon mapping between clusters and each unique sequence using `create_OTU_count_table-uclust_format.pl`

I believe that you can install the full [BioPerl](https://bioperl.org/index.html) dependency by entering a `cpan` shell and running `install Bundle::BioPerl` (as described [here](http://etutorials.org/Programming/perl+bioinformatics/Part+II+Perl+and+Bioinformatics/Chapter+9.+Introduction+to+Bioperl/9.2+Installing+Bioperl/)).

However, I think it is quicker to run `cpan Bio::SeqIO` for this particular script.

**4)** Similar to the original unique count tables, create summary plots.
