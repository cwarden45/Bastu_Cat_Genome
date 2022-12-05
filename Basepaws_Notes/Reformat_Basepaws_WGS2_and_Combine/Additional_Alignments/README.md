## Bacterial Reference Creation

This is something where it may help to discuss more with those that specialize in oral microbiology.

However, as a starting point, I have selected some sequences based upon at least one of the following categories:

**Category A: Brief Literature Search**

As discussed [here](https://github.com/cwarden45/Bastu_Cat_Genome/discussions/1), my understanding is that there is a **Red Complex** of bacteria affecting dental health (*Porphyromonas gingivalis*,*Treponema denticola*,*Tannerella forsythia*).

The exact species is different, but *Porphyromonas endodontalis* appeared in my [human dental health report](https://github.com/cwarden45/Bastu_Cat_Genome/discussions/1#discussioncomment-4082391).

<table>
  <tbody>
    <tr>
    	<th align="center">Genus</th>
	<th align="center">Species</th>
	 <th align="center">Accession to Test</th>
    </tr>
     <tr>
      <th align="center"><i>Porphyromonas</i></th>
      <th align="center"><i>gingivalis</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NC_010729.1/">NC_010729.1</a></th>
    </tr>
     <tr>
      <th align="center"><i>Treponema</i></th>
      <th align="center"><i>denticola</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NC_002967.9/">NC_002967.9</a></th>
    </tr>
     <tr>
      <th align="center"><i>Tannerella</i></th>
      <th align="center"><i>forsythia</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NC_016610.1/">NC_016610.1</a></th>
    </tr>
</tbody>
</table>

**Category B: Abundant Kraken2/Braken Assignments for My Human Oral Samples**

<table>
  <tbody>
    <tr>
    	<th align="center">Genus</th>
	<th align="center">Species</th>
	 <th align="center">Accession to Test</th>
    </tr>
     <tr>
      <th align="center"><i>Streptococcus</i></th>
      <th align="center"><i>oralis</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP097843.1">NZ_CP097843.1</a></th>
    </tr>
     <tr>
      <th align="center"><i>Rothia</i></th>
      <th align="center"><i>dentocariosa</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP079201.1">NZ_CP079201.1</a></th>
    </tr>
      <tr>
      <th align="center"><i>Veillonella</i></th>
      <th align="center"><i>parvula</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP019721.1">NZ_CP019721.1</a</th>
    </tr>
      <tr>
      <th align="center"><i>Prevotella</i></th>
      <th align="center"><i>denticola</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP072373.1">NZ_CP072373.1</a</th>
    </tr>
</tbody>
</table>

**Category C: Abundant Kraken2/Braken Assignments for Candidate False Positives**

<table>
  <tbody>
    <tr>
    	<th align="center">Genus</th>
	<th align="center">Species</th>
	 <th align="center">Accession to Test</th>
    </tr>
     <tr>
      <th align="center"><i>Komagataeibacter</i></th>
      <th align="center"><i>rhaeticus</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP050139.1">NZ_CP050139.1</a></th>
    </tr>
     <tr>
      <th align="center"><i>Burkholderia</i></th>
      <th align="center"><i>dolosa</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_JAJFOB000000000.1">Incomplete Assembly?</a></th>
    </tr>
     <tr>
      <th align="center"><i>Staphylococcus</i></th>
      <th align="center"><i>aureus</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP040625.1">NZ_CP040625.1</a></th>
    </tr>
     <tr>
      <th align="center"><i>Pseudomonas</i></th>
      <th align="center"><i>fluorescens</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP063233.1">NZ_CP063233.1</a></th>
    </tr>
</tbody>
</table>
	  
If I remember correctly, I beleive *Staphylococcus* is a genus where there was eventually a conclusion that Kraken2/Braken assignments in a sample that should have little or no bacterial contamination were most likely false positives (with reads in a joint alignment mostly being homopolymers).  However, the top species assignment is different for my Veritas WGS sample (which comes from only hg19-aligned chromosomes and really should contain no true bacterial sequences) and the Basepaws samples.  In particular, I thought I recognized the *Staphylococcus cohnii* species as being what was a likely false postiive in a different situation, and should almost certainly be a false positive in this situation.  However, I am primarily trying to troubleshoot the Basepaws WGS samples and *Staphylococcus aureus* was the top speies assignmetn for those.
	  
Selecting a species for the *Pseudomonas* was more difficult.  The top species was different in each sample (*Pseudomonas tolaasii* for the Veritas WGS with hg19-aligned reads that were unlikely to be true bacterial reads, *Pseudomonas fluorescens* for the 1st Basepaws WGS sample, and *Pseudomonas resinovorans* foro the 2nd Basepaws WGS sample).  However, 2 out of the 3 had the most reads assigned to a species within the "Pseudomonas fluorescens group".  At the same time, I think this might affect the Bowtie2 alignment the most: I think BWA-MEM will probably align reads from related species to a sequence representive for the genus (with the human and cat reference genomes being used to capture false positives in a joint reference, with this more sensitive alignment).

Relative to the [first "Top 20" heatmap with both oral and fecal samples](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/n29_FILTERED_Braken_genera-heatmap_quantified-TOP20.pdf), fastp filtering and trimming [substantially reduced ***Komagataeibacter*** assignments ](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/fastp_results/Oral6SUB3_FILTERED_Braken_genera-heatmap_quantified-TOP20.pdf) from appearing at a 72.4% non-feline read frequency to **not appearing in the filtered set of genera assignments** (with a frequency of less than 0.5%). 

**So, based upon those sequences trimmed and filtered by fastp with the `--length_required 100 --n_base_limit 0` parameters, an additional sequence for one more genus was added:**

<table>
  <tbody>
    <tr>
    	<th align="center">Genus</th>
	<th align="center">Species</th>
	 <th align="center">Accession to Test</th>
    </tr>
     <tr>
      <th align="center"><i>Capnocytophaga</i></th>
      <th align="center"><i>stomatis</i></th>
      <th align="center"><a href="https://www.ncbi.nlm.nih.gov/nuccore/NZ_CP022387.1">NZ_CP022387.1</a></th>
    </tr>
</tbody>
</table>

As an additional note, a decrease in ***Moraxella*** assignments is mentioned in the [general discussion](https://github.com/cwarden45/Bastu_Cat_Genome/discussions/1).  However, the species above focus on high abundance assignments, and the risk scores for Bastu were based upon *decreased* abundance of *Moraxella*.

For example, there is a row for *Moraxella* in the original Kraken2/Braken [raw count table](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/n29_FILTERED_Braken_genera-counts.txt) but not the [filtered percentages](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/n29_FILTERED_Braken_genera-heatmap_quantified.txt) considered for visualization.

In order to facilitate parsing information from the alignment, I edited the exact sequence names in the bacterial reference file *Bacteria11.fa* (which is uploaded on this page, as the compressed file **Bacteria11.fa.gz**).

## Bowtie2 Bacterial-Alone Alignment (fastp-filtered reads)

**0)** Create index using ``.

**1)** 

## BWA-MEM Joint Alignment (hg19+felCat9+Custom Bacteria, fastp-filtered reads)

**0)** Create index using ``.

**1)** Use `align_BWA_MEM-v2.py` from [Reformat_Basepaws_WGS2_and_Combine](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/align_BWA_MEM-v2.py).
