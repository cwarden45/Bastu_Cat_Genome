**Step 0)** If you don't already have an account, please [request an account](https://precision.fda.gov/request_access).

Also, if you already have an account, then you might want to take some time to familiarize yourself with the current interface.

For example, I had to learn/re-learn that the **Apps** created by others are under **My Home --> Everyone**.  Likewise, if you upload a file and then make that file **public**, then that file will appear from this location (rather default starting selection for *My Home --> Me*).

At least as of 12/22/2022, there is also general information [here](https://precision.fda.gov/docs/introduction).

**Step 1)** Small files can be uploaded from the web interface.  However, if Basepaws only provides data for Whole Genome Sequencing (WGS) customers, the you probably need to upload the files a different way.

**1a)** *Request a key* using a command Instructions that include Authorization Key generation are available [here](https://precision.fda.gov/assets/new).

**2a)** I uploaded my files using the Command Line Interface (CLI):

```
#!/bin/bash

KEY=[copy and paste temporary key for only your account]

/opt/pfda upload-file --key $KEY --file ../HCWGS0003.23.HCWGS0003_1.fastq.gz #Basepaws WGS1
/opt/pfda upload-file --key $KEY --file ../HCWGS0003.23.HCWGS0003_2.fastq.gz #Basepaws WGS1

/opt/pfda upload-file --key $KEY --file Basepaws_WGS2_R1.fastq.gz #Basepaws Reformatted WGS2
/opt/pfda upload-file --key $KEY --file Basepaws_WGS2_R2.fastq.gz #Basepaws Reformatted WGS2
```

If you wanted to compare to other oral samples for either Bastu (my cat) or myself (a human), then those are available within the following locations:

*Basepaws WGS1 (**cat**, described above)*: [R1](https://precision.fda.gov/home/files/file-GPjQ0Q008qqffP1KpJb66Jk8-1) [R2](https://precision.fda.gov/home/files/file-GPjQ2X808qqQFPxV2j86v8Z6-1)

*Basepaws WGS2 (**cat**, described above)*: [R1](https://precision.fda.gov/home/files/file-GPjPKX008qqbXFpGK681gFfZ-1) [R2](https://precision.fda.gov/home/files/file-GPjQ8pQ08qqZqZFPFG0xJYjK-1)


*Veritas WGS (only human-aligned from chromosome alignments, **approximate metagenomics negative control**)*: [R1](https://precision.fda.gov/home/files/file-FXyxPJQ0Vjj4FQVk354B168g-1) [R2](https://precision.fda.gov/home/files/file-FXyxPv80Vjj9b88QJz03kzKk-1)

*Nebula lcWGS (**human**, starting .fastq.gz)*: [R1](https://precision.fda.gov/home/files/file-Fb13k9j0Vjj5GjQXPQp5QFQF-1) [R2](https://precision.fda.gov/home/files/file-Fb13z000VjjBYJP2JbgyPVBb-1)

*Sequencing.com WGS (**human**, starting .fastq.gz)*: [R1](https://precision.fda.gov/home/files/file-GPjPVVj08qqV14j87GQ59BPz-1) [R2](https://precision.fda.gov/home/files/file-GPjPjKj08qqQ5GkGPVP8bFxB-1)

*Bristle Health (**human**, starting .fastq.gz)*: [R1](https://precision.fda.gov/home/files/file-GPjPJqj08qqQx5JVxzQjPKXB-1) [R2](https://precision.fda.gov/home/files/file-GPjPKG808qqXbVKx7Q3bK28j-1)

I encountered some problems with some files staying in the "closed" state for a long time (using the `pfda` command when running from Ubuntu).

In **Windows**, I copied the extracted executable into a given folder, and a ran a command in the following format (but with full text, not truely exported $KEY/$R1/$R2 variables):

```
pfda upload-file --key $KEY --file $R1
pfda upload-file --key $KEY --file $R2
```

Those large uploads were also not successfull.  *However, with the kind assistance of precisionFDA/DNAnexus staff, a group was created to import my files and proceed with analysis for the newer samples.*  **So, that was very helpful in being able to provide the full set of files above to others through precisionFDA!**

**3)** For new samples, any Basepaws reads in a format similar to Bastu's 2022 sample will need to be reformatted.

For local reformatting, I provide options through [create_PairedEnd_R1_and_R2.pl](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/create_PairedEnd_R1_and_R2.pl) (requiring use of comments to select groups of variable names) or [create_PairedEnd_R1_and_R2-external_input.pl](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/precisionFDA-Sharing_and_Analysis/create_PairedEnd_R1_and_R2-external_input.pl).  The later can be run from the command line as described below:

```
#!/bin/bash

SHORT=LP.858.D9.L1.R186
IN=../AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS.fastq.gz
R1OUT=AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS_R1.fastq.gz
R2OUT=AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS_R2.fastq.gz


perl create_PairedEnd_R1_and_R2-external_input.pl --id=$SHORT --in=$IN --r1=$R1OUT --r2=$R2OUT
```

If using the strategies above, you may need to concatinate reads between separate runs/lanes.

In terms of working to develop an App for precisionFDA, I created a summary markdown file (also uploaded in this folder) and I used the following command to upload an "asset" to use as an App:

I needed to make changes in the asset and App.  However, I think this is the right command to upload the content:

```
/opt/pfda upload-asset --key $KEY --name reformat_reduced_interleaved_FQ.tar.gz --root ./fakeroot/ --readme reformat_reduced_interleaved_FQ.md
```

With that command, I do not in fact create the .tar.gz file.  Intead, I created a folder called "***fakeroot***" (as well as subfolders */usr* and */usr/bin*), and I copied `create_PairedEnd_R1_and_R2-external_input.pl` into **/usr/bin*.  That was my attempt to better follow the instructions from [here](https://precision.fda.gov/docs/tutorials/apps-workflows#create-an-asset-with-code-and-data).

Importantly, within the App, I need to specify the Perl script as `/usr/bin/create_PairedEnd_R1_and_R2-external_input.pl` **not** `create_PairedEnd_R1_and_R2-external_input.pl` (with the extra `/usr/bin/` path).

I also had to be careful about the formatting for a file versus a variable with the `emit` function to create output files, and I also had to add `_path` to the input file.  This means that the script within the App was as follows:

```
perl /usr/bin/create_PairedEnd_R1_and_R2-external_input.pl --id=$SHORT --in="$IN_path" --r1=$R1OUT --r2=$R2OUT
emit "R1FILE" "$R1OUT"
emit "R2FILE" "$R2OUT"
```

So, as a possible option, [this app](https://precision.fda.gov/home/apps/app-GQ3zJ9j08Xq7v2Ky6fxb230K-1) can perform the reformatting.

However, two separate steps may still be needed.  For example, I do not know if other customers will tend to recieve 3 interleaved files or a different number of starting files.

**4)** Unless future availability changes, you might only be able to run a certain version of Kraken2.  However, based upon [these results](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/Additional_Kraken_Classifications/README.md) perhaps using more stringent criteria (like `Minimum number of hit groups` = **10**) for a given sized reference, use of only that version of Kraken2 might be sufficient?

I also set `Print scientific names instead of just taxids` to **True**.

As a note, with only that single non-default parameter changes, I recieved the following error message:

```
IOError: [Errno 28] No space left on device Low scratch storage space
```

My understanding is that the instance configuration needed to be changed, so I took that into consideration for additional troubleshooting to re-run analysis within precisionFDA with **High Disk 2**.

With **High Disk 2**, I recieve the following error message:

```
Loading database information...Failed attempt to allocate 8000000000bytes;
you may not have enough free memory to load this database.
If your computer has enough RAM, perhaps reducing memory usage from
other programs could help you load this database?
classify: unable to allocate hash table memory

gzip: stdout: Broken pipe

gzip: stdout: Broken pipe
```

So, I then testing Kraken2 using **High Mem 4**.  That job was **successful**.

**5)** I used downloaded those results and used `create_Kraken2_ONLY_table-INTERSPECIES_HOST-pFDA.R` to create the following plot:

![Local vs pFDA Kraken2 Assignments](VeritasWGS-Kraken2-Local_and_pFDA-cor.png "Local vs pFDA Kraken2 Assignments")

Similarly, I also analyzed the earlier Nebula lcWGS sample:

![Local vs pFDA Kraken2 Assignments](Nebula_lcWGS-Kraken2-Local_and_pFDA-cor.png "Local vs pFDA Kraken2 Assignments")

**So, I think might be encouraging that an unfiltered file (for Nebula lcWGS) shows *better* correlations than assignments made on only reads that could be aligned to hg19 (for the Vertias WGS file).**

After recieving help in importing the newer large files, I noticed an error message when running Kraken2:

```
confidence: value is not a float
```

I did not remember specifying non-default values for **Confidence score threshold** and **Minimum base quality** before, and I thought I had previously run *revision 2* of the precisionFDA app.

However, to be safe, I checked the local default settings:

```
  --confidence FLOAT      Confidence score threshold (default: 0.0); must be
                          in [0, 1].
  --minimum-base-quality NUM
                          Minimum base quality used in classification (def: 0,
                          only effective with FASTQ input).
```

So, I set both **Confidence score threshold** and **Minimum base quality** to be **0**, and I re-ran Kraken2 for the earlier 2 samples as well as the 2 new Basepaws WGS samples.  The output reports can be viewed in the folder below:

[Kraken2-230219](https://github.com/cwarden45/Bastu_Cat_Genome/tree/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/precisionFDA-Sharing_and_Analysis/Kraken2-230219)

*Specific Comparisons Are Also Shown Below:*

***Nebula lcWGS:*** [Kraken2_Full_Output](https://precision.fda.gov/home/files/file-GPk6f2802YPY8K4Q2F1Kb3Q2-1) [Kraken2_Report](https://precision.fda.gov/home/files/file-GPk6f3Q02YPbjQB7VVkYxxfQ-1)

![Local vs pFDA Kraken2 Assignments](230219-Nebula_lcWGS-Kraken2-Local_and_pFDA-cor.png "Local vs pFDA Kraken2 Assignments")

***Veritas hg19-aligned WGS (negative control approximation):*** [Kraken2_Full_Output](https://precision.fda.gov/home/files/file-GPk7F90039P5VbG9x3zp9Q52-1) [Kraken2_Report](https://precision.fda.gov/home/files/file-GPk7Gf0039PG4BZfbVJy8Y5f-1)

![Local vs pFDA Kraken2 Assignments](230219-VeritasWGS-Kraken2-Local_and_pFDA-cor.png "Local vs pFDA Kraken2 Assignments")

As before, I think might be encouraging that an unfiltered file (for Nebula lcWGS) shows *better* correlations than assignments made on only reads that could be aligned to hg19 (for the Vertias WGS file).

***Basepaws WGS Sample 1:*** [Kraken2_Full_Output](https://precision.fda.gov/home/files/file-GPk717802gJPgyXv6236bF5k-1) [Kraken2_Report](https://precision.fda.gov/home/files/file-GPk727002gJ8Z25Z8G83JFf4-1)

![Local vs pFDA Kraken2 Assignments](230219-Basepaws_WGS1-Kraken2-Local_and_pFDA-cor.png "Local vs pFDA Kraken2 Assignments")

I would guess the difference in the correlation above might relate to the smaller fragment shown below:

![Insert Distribution Across Samples](https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/Picard_Insert_Statistics/insert_size_density.png "Insert Distribution Across Samples")

Details for that plot are available [here](https://github.com/cwarden45/Bastu_Cat_Genome/tree/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/Picard_Insert_Statistics).

***Basepaws WGS Sample 2:*** [Kraken2_Full_Output](https://precision.fda.gov/home/files/file-GPk7JYQ08p06Qq3KQqqV7yFY-1) [Kraken2_Report](https://precision.fda.gov/home/files/file-GPk7KX008p03GZkz6PfK622V-1)

![Local vs pFDA Kraken2 Assignments](230219-Basepaws_WGS2-Kraken2-Local_and_pFDA-cor.png "Local vs pFDA Kraken2 Assignments")

The insert size is more similar to the human samples, and I would guess that might relates to an improved correlation relative to the first Basepaws sample?
