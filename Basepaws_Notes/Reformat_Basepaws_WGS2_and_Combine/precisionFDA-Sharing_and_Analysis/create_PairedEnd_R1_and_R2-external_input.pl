#!/bin/perl

use warnings;
use strict;
use diagnostics;
use Cwd 'abs_path'; 

$| =1;

#NOTE: This script creates .fastq files, and THEN compresses them.
#NOTE: Thus, the output name should be .fastq, not .fastq.gz.

my $os = $^O;
my $os_name;
if (($os eq "MacOS")||($os eq "darwin")||($os eq "linux"))
	{
		#Mac
		$os_name = "MAC";
	}#end if ($os eq "MacOS")
elsif ($os eq "MSWin32")
	{
		#PC
		$os_name = "PC";
	}#end if ($os eq "MacOS")
else
	{
		print "Need to specify folder structure for $os!\n";
		exit;
	}#end
	
if(scalar @ARGV < 1){
  warn "Missing input file\n";
  die usage();
}

my $short_name = "";
my $in_interleaved = "";
my $out_R1 = "";
my $out_R2 = "";
for (my $i=0; $i < scalar(@ARGV); $i++){
	if (($ARGV[$i] =~ /--help/) | ($ARGV[$i] =~ /-h/)){
		die usage();
	}elsif ($ARGV[$i] =~ /^--id=/){
		$short_name=$ARGV[$i];
		$short_name =~ s/--id=//;
	}elsif ($ARGV[$i] =~ /^--in=/){
		$in_interleaved=$ARGV[$i];
		$in_interleaved =~ s/--in=//;
	}elsif ($ARGV[$i] =~ /^--r1=/){
		$out_R1=$ARGV[$i];
		$out_R1 =~ s/--r1=//;
		$out_R1 =~ s/.gz$//;
	}elsif ($ARGV[$i] =~ /^--r2=/){
		$out_R2=$ARGV[$i];
		$out_R2 =~ s/--r2=//;
		$out_R2 =~ s/.gz$//;
	}
}#end for (my $i=0; $i < scalar(@ARGV); $i++)

print "Source ID (for Individual Reads): $short_name\n";
print "Interleaved Input .fastq.gz:      $in_interleaved\n";
print "Forward (R1) Output .fastq.gz:    $out_R1.gz\n";
print "Reverse (R2) Output .fastq.gz:    $out_R2.gz\n";

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

sub usage{
  print <<EOF

  Usage: perl MSigDB_to_BDfunc.pl --id=[short ID] --in=[in FQ] --r1=[out R1] --r2=[out R2]

  [short ID]  -  Unique identifier to add to reads (for downstream concatination)

  [in FQ]  -  Interleaved FASTQ File (compressed as .fastq.gz)
  
  [out R1]  -  Forward Output Read (compressed as .fastq.gz)
  
  [out R2]  -  Reverse Output Read (compressed as .fastq.gz)
					
EOF
    ;
  exit 1;
}