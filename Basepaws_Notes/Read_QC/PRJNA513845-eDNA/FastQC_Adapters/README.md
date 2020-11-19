For plotting the FastQC adapter percentages, values less than 1E-10 were set to that value (unless that is beyond the read length).

![Illumina Nextera Transposase Adapter"](FastQC_Nextera_Adapter_Results.png "Illumina Nextera Transposase Adapter")
![Illumina Universal Adapter"](FastQC_Universal_Adapter_Results.png "Illumina Universal Adapter")
![Illumina Small RNA 3prime Adapter"](FastQC_Small_RNA_3prime_Results.png "Illumina Small RNA 3prime Adapter")
![Illumina Small RNA 5prime Adapter"](FastQC_Small_RNA_5prime_Results.png "Illumina Small RNA 5prime Adapter")
![SOLiD Adapter"](FastQC_SOLiD_Adapter_Results.png "SOLiD Adapter")

---

**When I checked one of the samples for running cutadapt, it looks like the Nextera adapters were all removed but some Small RNA 3\` Adapters were still present.**

![Cutadapt-filtered Illumina Nextera Transposase Adapter"](Cutadapt-filtered_FastQC_Nextera_Adapter_Results.png "Illumina Nextera Transposase Adapter")
![Cutadapt-filtered Illumina Small RNA 3prime Adapter"](Cutadapt-filtered_FastQC_Small_RNA_3prime_Results.png "Illumina Small RNA 3prime Adapter")

This comes from the code in the [DADA2 section](https://github.com/cwarden45/Bastu_Cat_Genome/tree/master/Basepaws_Notes/Read_QC/PRJNA513845-eDNA/DADA2).

After re-downloading reads, there were 0  samples with all reads in the cutadapt-filtered files.  However, some samples have noticably more reads than others.
