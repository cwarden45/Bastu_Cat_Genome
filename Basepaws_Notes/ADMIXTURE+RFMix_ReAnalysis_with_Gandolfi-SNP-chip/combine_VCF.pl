use warnings;
use strict;
use diagnostics;

#copied and modified from https://github.com/cwarden45/DTC_Scripts/blob/master/Helix_Mayo_GeneGuide/IBD_Genetic_Distance/combine_VCF.pl

my $individual_ID = "Bastu";
my $individual_gender = 0;#female
my $sample_name = "basepaws";
my $VCF_Individual = "../felCat8.gatk.flagged.gVCF";
my $VCF_prev = "Gandolfi_felCat8.vcf";
my $VCF_Combined = "Gandolfi_felCat8_plus_Bastu.vcf";
my $prev_ped = "Gandolfi_felCat8.ped";
my $updated_ped = "Gandolfi_felCat8_plus_Bastu.ped";
my $GATK4_flag = 1;
my $large_flag = 1;

#add row at bottom of .ped file

open(OUTPUTFILE, ">$updated_ped") || die("Could not open $updated_ped!");

open(INPUTFILE, $prev_ped) || die("Could not open $prev_ped!");
while (<INPUTFILE>){
	$line_count++;
	my $line = $_;
	chomp $line;
	my @line_info = split("\t",$line);
	my $familyID = $line_info[0];
	my $sampleID = $line_info[1];
	my $patID = $line_info[2];
	my $matID = $line_info[3];
	my $gender = $line_info[4];
	my $phenotype = -9;

	print OUTPUTFILE "$familyID\t$sampleID\t$patID\t$matID\t$gender\t$phenotype\n";
}#end while (<INPUTFILE>)
			
close(INPUTFILE);

print OUTPUTFILE "$individual_ID\t$sample_name\t0\t0\t$individual_gender\t-9\n";

close(OUTPUTFILE);

#define positions to combine
my %individual_hash;

if($large_flag == 1){
	print "Only save lines already in larger file\n";
	
	open(INPUTFILE, $VCF_prev) || die("Could not open $VCF_prev!");
	while (<INPUTFILE>){
		$line_count++;
		my $line = $_;
		chomp $line;
		if (!($line =~ /^##/)){
			my @line_info = split("\t",$line);
			my $chr = $line_info[0];
			my $pos = $line_info[1];
			my $ref = $line_info[3];	
			my $alt = $line_info[4];

			$chr =~ s/^chr//;

			if(!($line =~ /^#/)){			
				my $varID = "$chr:$pos:$ref:$alt";
				$individual_hash{$varID}="";
			}#end else
		}#end if (!($line =~ /^##/))
	}#end while (<INPUTFILE>)
				
	close(INPUTFILE);	
}#end if($large_flag == 1)

print "Reading individual VCF...\n";

my %chr_map_hash;
$chr_map_hash{"chrA1"}=1;
$chr_map_hash{"chrA2"}=2;
$chr_map_hash{"chrA3"}=3;
$chr_map_hash{"chrB1"}=4;
$chr_map_hash{"chrB2"}=5;
$chr_map_hash{"chrB3"}=6;
$chr_map_hash{"chrB4"}=7;
$chr_map_hash{"chrC1"}=8;
$chr_map_hash{"chrC2"}=9;
$chr_map_hash{"chrD1"}=10;
$chr_map_hash{"chrD2"}=11;
$chr_map_hash{"chrD3"}=12;
$chr_map_hash{"chrD4"}=13;
$chr_map_hash{"chrE1"}=14;
$chr_map_hash{"chrE2"}=15;
$chr_map_hash{"chrE3"}=16;
$chr_map_hash{"chrF1"}=17;
$chr_map_hash{"chrF2"}=18;
$chr_map_hash{"chrX"}=19;

$line_count=0;
open(INPUTFILE, $VCF_Individual) || die("Could not open $VCF_Individual!");
while (<INPUTFILE>){
	$line_count++;
	my $line = $_;
	chomp $line;


	if(!($line =~ /^#/)){
		#print "$line\n";

		my @line_info = split("\t",$line);
		my $chr = $line_info[0];
		my $pos = $line_info[1];
		my $ID = $line_info[2];
		my $ref = $line_info[3];	
		my $alt = $line_info[4];
		my $qual = $line_info[5];
		my $filter = $line_info[6];
		my $info = $line_info[7];
		my $format = $line_info[8];
		my $geno = $line_info[9];
		
		if(exists($chr_map_hash{$chr})){
			$chr=$chr_map_hash{$chr};
			
			if($GATK4_flag == 1){
			
				if($alt eq "<NON_REF>"){
					$alt = $ref;
				}else{
					$alt =~ s/,<NON_REF>//;
				}
				
				$geno = substr($line_info[9],0,3);
				
				if(($geno eq "")|($geno eq "   ")){
					$geno="./.";
					print "Corrected empty geno value\n";
				}elsif(!$geno =~ /\//){
					print "Wrong formatting for |$geno|\n";
					exit;
				}
			}#end if(($GATK4_flag == 1)&($alt eq "<NON_REF>"))

			my $varID = "$chr:$pos:$ref:$alt";
			#print "$varID\n";
			
			if($large_flag == 1){
				unless(exists($individual_hash{$varID})){
					$filter = "FAIL";
				}#end unless(exists($individual_hash{$varID}))
			}#end if($large_flag == 1)
			
			if($filter eq "PASS"){
				$individual_hash{$varID}=$geno;
			}#end if($filter eq "PASS")
		}#end if(exists($chr_map_hash{$chr}))
	}#end if(!($line =~ /^#/))
}#end while (<INPUTFILE>)
			
close(INPUTFILE);

#define indices to count, output allele frequencies

print "Reading and appending Gandolfi SNP chip VCF...\n";

open(OUTPUTFILE, ">$VCF_Combined") || die("Could not open $VCF_Combined!");

my @output_indices;


open(INPUTFILE, $VCF_prev) || die("Could not open $VCF_prev!");
while (<INPUTFILE>){
	my $line = $_;
	chomp $line;
	if (!($line =~ /^##/)){
		my @line_info = split("\t",$line);
		my $chr = $line_info[0];
		my $pos = $line_info[1];
		my $ID = $line_info[2];
		my $ref = $line_info[3];	
		my $alt = $line_info[4];
		my $qual = $line_info[5];
		my $filter = $line_info[6];
		my $info = $line_info[7];
		my $format = $line_info[8];

		$chr =~ s/^chr//;

		if(!($line =~ /^#/)){			
			my $varID = "$chr:$pos:$ref:$alt";
			
			if(exists($individual_hash{$varID})){
				if($individual_hash{$varID} ne ""){
					my $extra_geno = $individual_hash{$varID};
					print OUTPUTFILE "$line\t$extra_geno\n";
				}#end if($individual_hash{$varID} ne "")
			}#end if(exists($sample_hash{$sample}))		
		}else{
			print OUTPUTFILE "$line\t$sample_name\n";
		}#end else
	}#end if (!($line =~ /^##/))
}#end while (<INPUTFILE>)
			
close(INPUTFILE);
close(OUTPUTFILE);

exit;
