use warnings;
use strict;
use diagnostics;

my $pos_file = "../Cat_SNP_Chip/Supplementary_data_file_2_CatArrayMap.map";
my $gVCF = "SRR5055389-felCat8.gatk.flagged.gVCF";
my $filtered_file = "Cinnamon_felCat8_array-matched.vcf";

#create position hash
print "Find positions to output..\n";
my %pos_hash;

open(INPUT, $pos_file) || die("Could not open $pos_file!");
while (<INPUT>){
		my $line = $_;
		chomp $line;
		$line =~ s/\r//g;
		$line =~ s/\n//g;
		my @line_info = split("\t", $line);
		my $chr=$line_info[0];
		my $pos=$line_info[3];
		my $varID = "$chr:$pos";
		$pos_hash{$varID}=1
	}#end while (<INPUT>)
close(INPUT);

#create has to convert chromosome IDs
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

#output specific variant positions
print "Read though gVCF..\n";

open(OUTPUTFILE, ">$filtered_file") || die("Could not open $filtered_file!");

open(INPUTFILE, $gVCF) || die("Could not open $gVCF!");
while (<INPUTFILE>){
	my $line = $_;
	chomp $line;


	if($line =~ /^#CHROM/){
		print OUTPUTFILE "$line\n";
	}elsif(!($line =~ /^#/)){
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
			
			my $varID = "$chr:$pos";
			
			if(exists($pos_hash{$varID})){
			
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
				
				print OUTPUTFILE "$chr\t$pos\t$ID\t$ref\t$alt\t$qual\t$filter\t.\tGT\t$geno\n";
			}#end if(exists($pos_hash{$varID})))
		}#end if(exists($chr_map_hash{$chr}))
	}#end if(!($line =~ /^#/))
}#end while (<INPUTFILE>)
			
close(INPUTFILE);

close(OUTPUTFILE);

exit;