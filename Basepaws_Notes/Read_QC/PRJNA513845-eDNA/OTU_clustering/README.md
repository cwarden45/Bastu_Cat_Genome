
**1)** Collect unique sequences into 1 file using `combine_unique_sequences.py`

**2)** Run one of the following OTU clustering methods

*a)* [swarm](https://github.com/torognes/swarm)

The input FASTA file is created using `combine_unique_sequences-multiread-swarm.py`

Swarm is then run using `run_swarm.py`.

This ran successfully and was faster than VSEARCH for the set of sequences present in at least 2 reads for at least 1 sample.  So, I will test Swarm with the full set of reads.


*b)* [vsearch](https://github.com/torognes/vsearch) using `run_vsearch.py`


**3)** Create revised table of counts based upon mapping between clusters and each unique sequence
