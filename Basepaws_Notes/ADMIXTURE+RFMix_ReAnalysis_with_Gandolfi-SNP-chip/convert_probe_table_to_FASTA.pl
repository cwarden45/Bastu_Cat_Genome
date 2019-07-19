use warnings;
use strict;
use diagnostics;

my $input_table = "41598_2018_25438_MOESM4_ESM_Full-Mapping-Table4.txt";
my $output_FASTA = "Gandolfi_Cat_SNPchip_probes.fa";
my $BLAST_PATH = "/opt/ncbi-blast-2.9.0+/bin";
my $BLAST_ref = "felCat9.fa";
my $BLAST_output = "felCat9_BLAST_output.txt";

open(OUT, ">$output_FASTA") || die("Could not open $output_FASTA!");

open(IN, $input_table) || die("Could not open $input_table!");

while (<IN>){
	my $line = $_;
	chomp $line;
	$line =~ s/\r//g;
	my @line_info = split("\t",$line);
	my $probeID = $line_info[0];
	my $probe_values = $line_info[7];
	my $ref_base = $line_info[8];
	my $probe_seq = $line_info[9];
	
	if ($probe_seq ne "*"){
		#print "$probeID|$probe_values|$ref_base|$probe_seq|\n";
		#print substr($probe_seq,0,3),"\n";
		my $felCat8_strand = "-";
		if(substr($probe_seq,0,3) eq $ref_base){
			#print "Confirm positive strand\n";
			$felCat8_strand = "+";
		}

		$probe_values =~ s/\[//;
		$probe_values =~ s/\///;
		$probe_values =~ s/\]//;
		
		$ref_base =~ s/\[//;
		$ref_base =~ s/\]//;

		$probe_seq =~ s/\[//;
		$probe_seq =~ s/\]//;
		
		#change nucleotide values to match probe sequence AND genotypes in matrix (which I believe is already switched, to indicate felCat8 stand)
		if($felCat8_strand eq "+"){
			$ref_base =~ tr/ATGCatgc/TACGtacg/;
			$probe_seq = revcom($probe_seq);
		}
		#remember that informative nucleotide is at end of probe_not beginning of probe
		my $var_pos = length($probe_seq);
		
		my $faID = "$probeID\_$var_pos\_$probe_values\_$ref_base";
		print OUT ">$faID\n$probe_seq\n";
	}#end if ($probe_seq ne "*")

}#end while (<IN>)

close(IN);
close(OUT);

my $command = "$BLAST_PATH/makeblastdb -in $BLAST_ref -dbtype nucl";
#system($command);

#intentially don't add -num_alignments 1, so that I can filter multi-mapped probes
$command = "$BLAST_PATH/blastn -evalue 1e-10 -query $output_FASTA -db $BLAST_ref -out $BLAST_output -outfmt \"6 qseqid qlen qstart qend sseqid slen sstart send length pident nident mismatch gaps evalue\"";
system($command);

exit;

sub revcom{
	my $seq = shift;
	
	#copied from https://gist.github.com/dnatag4snippet/4624375
	$seq = reverse $seq;
	$seq =~ tr/ATGCatgc/TACGtacg/;
	
	return $seq;
}#end def revcom