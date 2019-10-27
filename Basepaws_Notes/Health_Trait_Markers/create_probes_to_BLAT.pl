use warnings;
use strict;
use diagnostics;
use Bio::SeqIO;

my %variant_hash = ("NM_001009190.1","ASIP_122_123delCA:122",
					"NM_001079655.1","MLPH_83delT:83");
my $UCSC_RefSeq_FA = "felCat9_RefSeq.fa";
my $BLAT_query = "BLAT_BLAST_Probes.fa";

open(BLAT, ">$BLAT_query") || die("Could not open $BLAT_query!");

my $seqio_object = Bio::SeqIO->new(-file => $UCSC_RefSeq_FA); 

while (my $seq = $seqio_object->next_seq){
   my $id=$seq->id;
   if(exists($variant_hash{$id})){
		my $cDNA = $seq->seq;
		
		my $info_text= $variant_hash{$id};
		my @info_arr = split(":", $info_text);
		
		my $var_name = $info_arr[0];
		my $pos = int($info_arr[1]);
		
		my $test = substr($cDNA,$pos-1,25);
		print BLAT ">$var_name\n$test\n";
   }#end if(exists($variant_hash{$id})
}#end while (my $seq = $inseq->next_seq)

close(BLAT);


exit;