use warnings;
use strict;
use diagnostics;

my $Cinnamon_mapping_file = "../Cinnamon_WGS/Cinnamon_felCat8_array-matched-PLUS_S5_values.txt";

print "Define hash for homozygous Cinnamon felCat8 sites...\n";

my %Cinnamon_ref_hash;

open(CIN, $Cinnamon_mapping_file) || die("Could not open $Cinnamon_mapping_file!");

while (<CIN>){
	my $line = $_;
	chomp $line;
	$line =~ s/\r//g;
	
	if(!($line =~ /^#/)){
		my @line_info = split("\t",$line);
		my $chr = $line_info[0];
		my $pos = $line_info[1];
		my $ref = $line_info[3];
		my $var = $line_info[4];#only works if variant was observed
		my $filter = $line_info[6];
		my $wgs_geno = $line_info[9];
		my $array1 = $line_info[10];
		my $array2 = $line_info[11];
	
		if (($filter eq "PASS")&($array1 eq $array2)){
			my $allele1 = substr($array1,0,1);
			my $allele2 = substr($array1,1,1);
			
			if ($allele1 eq $allele2){
				my $varID = "$chr:$pos";

				if($wgs_geno eq "0/0"){
					if($allele1 eq $ref){
						$Cinnamon_ref_hash{$varID}="REF_POS_$allele1";
					}else{
						my $revcom = $allele1;
						$revcom =~ tr/ATGCatgc/TACGtacg/;
						
						if($revcom eq $ref){
							$Cinnamon_ref_hash{$varID}="REF_NEG_$allele1";
						}else{
							print "Issue mapping $line\n";
						}
					}#end else
				}#end if($wgs_geno eq "0/0")


				if($wgs_geno eq "1/1"){
					if($allele1 eq $var){
						$Cinnamon_ref_hash{$varID}="VAR_POS_$allele1";
					}else{
						my $revcom = $allele1;
						$revcom =~ tr/ATGCatgc/TACGtacg/;
						
						if($revcom eq $var){
							$Cinnamon_ref_hash{$varID}="VAR_NEG_$allele1";
						}else{
							print "Issue mapping $line\n";
						}
					}#end else
				}#end if($wgs_geno eq "0/0")
				
			}#end if ($allele1 eq $allele2)
		}#end 
	
	}#end if(!($line =~ /^#/))
}#end while (<STRAND>)

close(CIN);

print "Maximum of ".scalar(keys %Cinnamon_ref_hash)." positions that can be mapped based upon Cinnamon WGS data.\n";


exit;