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
      <th align="center"><a href=""></a</th>
    </tr>
     <tr>
      <th align="center"><i>Treponema</i></th>
      <th align="center"><i>denticola</i></th>
      <th align="center"><a href=""></a</th>
    </tr>
     <tr>
      <th align="center"><i>Tannerella</i></th>
      <th align="center"><i>forsythia</i></th>
      <th align="center"><a href=""></a</th>
    </tr>
</tbody>
</table>

**Category B: Abundant Kraken2/Braken Assignments for My Human Oral Samples**

**Category C: Abundant Kraken2/Braken Assignments for Candidate False Positives**

A decrease in ***Moraxella*** assignments is mentioned in the [general discussion](https://github.com/cwarden45/Bastu_Cat_Genome/discussions/1).  However, the species above focus on high abundance assignments, and the risk scores for Bastu were based upon *decreased* abundance of *Moraxella*.

For example, there is a row for *Moraxella* in the original Kraken2/Braken [raw count table](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/n29_FILTERED_Braken_genera-counts.txt) but not the [filtered percentages](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/n29_FILTERED_Braken_genera-heatmap_quantified.txt) considered for visualization.

In order to facilitate parsing information from the alignment, I edited the exact sequence names in the bacterial reference file *.fa* (which is uploaded on this page, as the compressed file **.fa.gz**).

## Bowtie2 Bacterial-Alone Alignment (fastp-filtered reads)

**0)** Create index using ``.

**1)** 

## BWA-MEM Joint Alignment (hg19+felCat9+Custom Bacteria, fastp-filtered reads)

**0)** Create index using ``.

**1)** Use `align_BWA_MEM-v2.py` from [Reformat_Basepaws_WGS2_and_Combine](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/align_BWA_MEM-v2.py).
