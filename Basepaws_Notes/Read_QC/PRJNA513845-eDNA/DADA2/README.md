The first steps of analysis are meant to match the [comment discussion](https://www.nature.com/articles/s41598-019-42455-9#article-comments) for the eDNA paper.

**1)** Trim adapters using [cutadapt](https://cutadapt.readthedocs.io/en/stable/) with `run_cutadapt.py`

You can also run `collect_FastQC_adapters.py` and `plot_adapter_results.R` to summarize the effect of the cutadapt trimming.

![Remaining Reads after Cutadapt](Cutadapt-filtered_read_counts-with_sequencer.png "Read Counts by Sequencer")

**2)** Run [DADA2](https://benjjneb.github.io/dada2/tutorial.html) using `run_DADA2-by_machine.R` or `run_DADA2-separate_serial.R`

I am skipping the 4 PhiX outliers, but it looks like running cutadapt removed a lot of the PhiX NovaSeq reads (when they would have been present at <1% frequency)?  This would match a response from the authors in the comment thead.

**3)** Summarize DADA2 merged and corrected sequence counts.

**4)** For comparison, merge sequences using [PEAR](https://cme.h-its.org/exelixis/web/software/pear/) (`run_PEAR.py`) and/or [FLASH](https://ccb.jhu.edu/software/FLASH/) (`run_FLASH.py`) and count unique sequences using [mothur](https://mothur.org/) (`run_mothur-unique_seqs.py`).

*4a)* Use `reformat_unique_FASTA.py` to combine information from the mothur files (and perhaps later be modified for sequence features).
