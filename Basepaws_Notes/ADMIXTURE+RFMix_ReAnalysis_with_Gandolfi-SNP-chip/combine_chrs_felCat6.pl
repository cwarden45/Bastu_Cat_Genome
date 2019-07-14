use warnings;
use strict;
use diagnostics;
use Bio::SeqIO;

#download from 

my @cat_chr = ("chrMT",
				"chrA1","chrA2","chrA3",
				"chrB1","chrB2","chrB3","chrB4",
				"chrC1","chrC2",
				"chrD1","chrD2","chrD3","chrD4",
				"chrE1","chrE2","chrE3",
				"chrF1","chrF2",
				"chrX");
				
my $outFa="felCat6.fa";

open(OUTPUTFILE, ">$outFa") || die("Could not open $outFa!");

				
foreach my $chr (@cat_chr){
	print "$chr...\n";
	print OUTPUTFILE ">$chr\n";
	
	my $inFa = "fca_ref_Felis_catus-6.2_$chr.fa";
	
	my $seqio_object = Bio::SeqIO->new(-file => $inFa); 
	my $seq_object = $seqio_object->next_seq;
	my $seq = $seq_object->seq;
	print OUTPUTFILE "$seq\n";
}#end foreach my $chr (@cat_chr)

close(OUTPUTFILE);

exit;