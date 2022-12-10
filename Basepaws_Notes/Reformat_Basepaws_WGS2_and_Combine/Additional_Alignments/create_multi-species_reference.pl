#!/bin/perl

use strict;
use Bio::SeqIO;

my $human_name = "hg19";
my $human_fa = "/home/cwarden/Ref/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa";
my $cat_name = "felCat9";
my $cat_fa = "/mnt/usb8/Bastu_Cat_Genome/felCat9.fa";
my $bacteria_fa = "/mnt/usb8/Bastu_Cat_Genome/WGS2/Additional_Alignments/Bacteria11.fa";
my $combined_fa = "hg19_felCat9_Bacteria11.fa";

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