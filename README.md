I have uploaded a report from the [UC-Davis VGL](https://www.vgl.ucdavis.edu/services/cat/), and I will update [basepaws](https://www.basepaws.com/) reports when they are available.

I don't have any raw data for the UC-Davis VGL sample, but I do have an [earlier blog post for the report for another cat](http://cdwscience.blogspot.com/2013/01/stormys-feline-dna-test.html) (and I hope some of my re-analysis of the basepaws raw data will hopefully be able to make use of data from the lab that developed that test).

The UC-Davis VGL sample collection was a cytobrush.

I submitted two different samples for Bastu for basepaws.  The first was a hair sample, and the second was a swab.

I was sent the swab when I requested higher coverage sequencing data (or, more precisely, I asked about raw data, and I then learned more about the protocol and the option for raw data for higher coverage sequencing).

While I know that extra experiments are required for health / traits (as mentioned [this comment](https://www.instagram.com/p/Bu1uXAsAI6J/?fbclid=IwAR3TgmQ-wVweKm9bmzZFVgP-6vJAjfq8jeEMALVuwQa_XvO4cxtmgJos9Uw)), the **$95** basepaws kit is meant to cover 0.5x sequencing.  So, I paid an additional **$1000** for 15x sequencing (as I understand it, for the 2nd sample).

I believe this is the time-line for sample collection / processing:

**UC-Davis VGL (Ancestry Test, $120)**:

Purchased Test on 11/16/2018

Sample Recieved on 11/27/2018

Recieved Report on 2/25/2018 (*~so, a little more than 3 months turn-around time*)

**basepaws (hair sample, $95, ~0.5x sequencing, possibly other types later?)**:

Purchased Test on 2/24/2019

Activated Kit / Collected Sample on 3/1/2019

*Waiting to recieve Report*

**basepaws (mouth swab, $1000, ~15x sequencing, with raw data as FASTQ+BAM+gVCF)**:

Purchased Test on 3/7/2019

Activated Kit / Collected Sample on 3/14/2019

Learned data was available on 5/24/2019

Data available from AWS S3 bucket on 6/13/2019

*Waiting to recieve Report? (I'm not sure if the same report is provided for the higher coverage sequencing data)*

I'm not sure if basepaws will implement automatic deposit into the SRA (with owner's permission).  However, I have re-uploaded my raw FASTQ files here:

basepaws 15x WGS Read1: https://storage.googleapis.com/bastu-cat-genome/HCWGS0003.23.HCWGS0003_1.fastq.gz
basepaws 15x WGS Read2: https://storage.googleapis.com/bastu-cat-genome/HCWGS0003.23.HCWGS0003_2.fastq.gz

I still have money left from my $300 Google Cloud credit, but I don't know how much the charge is for people to download from a public link.  However, that should be available in the immediate future.  I was also guessing that the S3 data was duplicated (and may be deleted).  However, while available, I could also post those links (if I encounter a problem with Google Cloud bucket).

If I understand what they processed for the higher coverage sequencing, some people might be concerned the later sample was processed first.  However, I would actually prefer to the samples processed in different runs (just in case I am able to detect batch effects, influenced by the other samples in the run).
