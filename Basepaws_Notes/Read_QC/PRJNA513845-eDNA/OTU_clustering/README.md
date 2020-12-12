
**1)** Collect unique sequences into 1 file using `combine_unique_sequences.py` or `combine_unique_sequences-multiread.py` (*I think the later is probably preferable* - this decreases the file size by an order of magnitude, even if only requiring at least 2 reads for a sequence in at least 1 sample)

**2)** Run one of the following OTU clustering methods


*a)* [vsearch](https://github.com/torognes/vsearch) using `run_vsearch.py`
*b)*

**3)** Create revised table of counts based upon mapping between clusters and each unique sequence
