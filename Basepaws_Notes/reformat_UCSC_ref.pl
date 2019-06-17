#!/bin/perl

use strict;
use Bio::SeqIO;

my $inputfile = "felCat9.fa";
my $outputfile = "felCat9_basepawsNum.fa";

#refreshed my memory using https://bioperl.org/howtos/SeqIO_HOWTO.html

my %chr_hash;
$chr_hash{"chrA1"}=1;
$chr_hash{"chrA2"}=2;
$chr_hash{"chrA3"}=3;
$chr_hash{"chrB1"}=4;
$chr_hash{"chrB2"}=5;
$chr_hash{"chrB3"}=6;
$chr_hash{"chrB4"}=7;
$chr_hash{"chrC1"}=8;
$chr_hash{"chrC2"}=9;
$chr_hash{"chrD1"}=10;
$chr_hash{"chrD2"}=11;
$chr_hash{"chrD3"}=12;
$chr_hash{"chrD4"}=13;
$chr_hash{"chrE1"}=14;
$chr_hash{"chrE2"}=15;
$chr_hash{"chrE3"}=16;
$chr_hash{"chrF1"}=17;
$chr_hash{"chrF2"}=18;
$chr_hash{"chrM"}=20;#order switched in .bam header
$chr_hash{"chrX"}=19;


open(OUT, "> $outputfile")||die("Cannot open $outputfile\n");

my $seqio_object = Bio::SeqIO->new(-file => $inputfile); 
while (my $seq = $seqio_object->next_seq) {
   my $chr =  $seq->id;
   if(exists($chr_hash{$chr})){
		print "Writing ",$chr_hash{$chr},"...\n";
		print OUT ">",$chr_hash{$chr},"\n";
		print OUT $seq->seq,"\n";
   }#end if(exists($chr_hash{$chr}))
}#end while (my $seq = $seqio_object->next_seq)

close(OUT);

exit;