use warnings;
use strict;
use diagnostics;

my $input_ped = "Gandolfi_felCat8_plus_Bastu.ped";
my $output_pop = "Gandolfi_felCat8_plus_Bastu.pop";
my $mapping_file = "fromHasan/FID_breed_codes_fromHasan.txt";#if you want to change the mapping, you'll have to modify this code (and either over-write the other file, or save the files in another location)

#create ancestry hash
my %ancestry_hash;

my $line_count=0;
open(INPUTFILE, $mapping_file) || die("Could not open $mapping_file!");
while (<INPUTFILE>){
	$line_count++;
	my $line = $_;
	chomp $line;

	if($line_count > 1){
		my @line_info = split("\t",$line);
		my $FID = $line_info[0];
		my $ancestry = $line_info[3];#2-group, Eastern versus Western
		if($ancestry eq "Eastern"){
			$ancestry_hash{$FID}=$ancestry;
		}elsif($ancestry eq "Western"){
			$ancestry_hash{$FID}=$ancestry;
		}else{
			print "Skipping: $line\n";
		}

	}#end if($line_count > 1)
}#end while (<INPUTFILE>)
			
close(INPUTFILE);

#create pop file
open(OUT, ">$output_pop") || die("Could not open $output_pop!");

open(INPUTFILE, $input_ped) || die("Could not open $input_ped!");
while (<INPUTFILE>){
	$line_count++;
	my $line = $_;
	chomp $line;

	my @line_info = split("\t",$line);
	my $FID = $line_info[0];
	if(exists($ancestry_hash{$FID})){
		print OUT $ancestry_hash{$FID},"\n";
	}else{
		print OUT "-\n";
	}
}#end while (<INPUTFILE>)
			
close(INPUTFILE);

close(OUT);

exit;