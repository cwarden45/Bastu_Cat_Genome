#!/bin/perl

#copy code from https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Reformat_Basepaws_WGS2_and_Combine/Additional_Alignments/create_multi-species_reference.pl

#add Feline calicivirus (NC_075569.1) to reference set  -- however, ss-RNA should NOT really be present
#Wikipedia entry (https://en.wikipedia.org/wiki/Feline_calicivirus) also listed Feline viral rhinotracheitis
#so, also add Feline calicivirus (NC_075569.1) to reference set 
#also add FeLV(NC_001940.1) and FIV (NC_001482.1), based upon https://www.sciencedirect.com/science/article/abs/pii/016524279190048H
#add FCoV (DQ848678.1), based upon https://www.researchgate.net/publication/300001985_Prevalence_of_systemic_disorders_in_cats_with_oral_lesions (and, likely, others)
#add Feline infectious peritonitis virus (call "FIPV", NC_002306.3), based upon RefSeq search for "Feline Coronavirus"
#many of these are mentioned in https://www.frontiersin.org/journals/veterinary-science/articles/10.3389/fvets.2017.00209/full, without additional references
#I also searched for feline papliomaviruses (OQ836188.1 and LC612600.1), based upon https://onlinelibrary.wiley.com/doi/abs/10.1111/vco.12569

#also, add Feline Panleukemia Virus (KP280068.1)

#as an intended negative control, I also added a rabies virus genome sequence (NC_001542.1).

use strict;
use Bio::SeqIO;

my $human_name = "hg19";
my $human_fa = "/home/cwarden/Ref/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa";
my $cat_name = "felCat9";
my $cat_fa = "/mnt/usb8/Bastu_Cat_Genome/felCat9.fa";
my $bacteria_fa = "/mnt/usb8/Bastu_Cat_Genome/MissYvonne_Cat_Genome/Bacteria11Virus10.fa";
my $combined_fa = "hg19_felCat9_Bacteria11Virus10.fa";

open(OUT, "> $combined_fa")||die("Cannot open $combined_fa\n");

#human
my $seq_in = Bio::SeqIO->new( -file   => "$human_fa",
                              -format => "FASTA");

while (my $inseq = $seq_in->next_seq){
	my $id = $inseq->id;
	my $seq = $inseq->seq;
	my $seq = $inseq->seq;
	print OUT ">$human_name\_$id\n$seq\n";
}#end while (my $inseq = $seq_in->next_seq)

#cat
my $seq_in = Bio::SeqIO->new( -file   => "$cat_fa",
                              -format => "FASTA");

while (my $inseq = $seq_in->next_seq){
	my $id = $inseq->id;
	my $seq = $inseq->seq;
	my $seq = $inseq->seq;
	print OUT ">$cat_name\_$id\n$seq\n";
}#end while (my $inseq = $seq_in->next_seq)

#bacteria
my $seq_in = Bio::SeqIO->new( -file   => "$bacteria_fa",
                              -format => "FASTA");

while (my $inseq = $seq_in->next_seq){
	my $id = $inseq->id;
	my $seq = $inseq->seq;
	my $seq = $inseq->seq;
	print OUT ">$id\n$seq\n";
}#end while (my $inseq = $seq_in->next_seq)

close(OUT);

my $command = "/opt/samtools/samtools faidx $combined_fa";
system($command);

$command = "/opt/bwa-0.7.17/bwa index $combined_fa";
system($command);

exit;