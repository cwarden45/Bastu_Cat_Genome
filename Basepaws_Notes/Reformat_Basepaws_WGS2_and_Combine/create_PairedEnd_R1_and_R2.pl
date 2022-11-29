#!/bin/perl

use strict;
use Bio::SeqIO;

#NOTE: This script creates .fastq files, and THEN compresses them.
#NOTE: Thus, the output name should be .fastq, not .fastq.gz.

my $short_name = "LP.858.D9.L1.R186";
my $in_interleaved = "AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS.fastq.gz";
my $out_R1 = "AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS_R1.fastq";
my $out_R2 = "AB.CN.45.31211051000777.LP.858.D9.L1.R186.WGS_R2.fastq";

#my $short_name = "SP.319.D1.L2.R186";
#my $in_interleaved = "AB.CN.45.31211051000777.SP.319.D1.L2.R186.WGS.fastq.gz";
#my $out_R1 = "AB.CN.45.31211051000777.SP.319.D1.L2.R186.WGS_R1.fastq";
#my $out_R2 = "AB.CN.45.31211051000777.SP.319.D1.L2.R186.WGS_R2.fastq";

#my $short_name = "SP.329.E1.L2.R195";
#my $in_interleaved = "AB.CN.45.31211051000777.SP.329.E1.L2.R195.WGS.fastq.gz";
#my $out_R1 = "AB.CN.45.31211051000777.SP.329.E1.L2.R195.WGS_R1.fastq";
#my $out_R2 = "AB.CN.45.31211051000777.SP.329.E1.L2.R195.WGS_R2.fastq";

#use example from https://stackoverflow.com/questions/59899310/how-to-read-data-in-gz-file-very-fast-in-perl-programming

open(R1, "> $out_R1")||die("Cannot open $out_R1\n");
open(R2, "> $out_R2")||die("Cannot open $out_R2\n");

my $line_count = 0;

open my $zcat, "zcat $in_interleaved |";
while (<$zcat>) {
	my $line = $_;
	
	$line_count +=1;
	my $relative_index = $line_count %8;
	my $read_pair = int(($line_count-1) /8 + 1);
	
	#print "$read_pair : $relative_index : $line\n";
	my $newID = "$short_name:$read_pair";
	
	if ($relative_index == 1){
		#create new name for R1
		print R1 "@".$newID."/1\n";
	}elsif(($relative_index >= 2)&($relative_index <=4)){
		print R1 $line; 
	}elsif ($relative_index == 5){
		#create new name for R2
		print R2 "@".$newID."/2\n";
	}else{
		print R2 $line; 
	}#end else
  
	#if ($line_count == 20){
		#	  exit;
	#}
	
	if($line_count % 800000 == 0){
		my $million_count = ($line_count/8) / 1000000;
		printf("Processed %.1fM read pairs...\n",$million_count);
	}#end if($line_count % 80000 == 0)
}#end while (<$zcat>) 
close $zcat;

close(R1);
close(R2);

print "Compresssing Forward Read in Pair (R1)...\n";
my $command = "gzip $out_R1";
system($command);

print "Compresssing Reverse Read in Pair (R2)...\n";
$command = "gzip $out_R2";
system($command);

exit;