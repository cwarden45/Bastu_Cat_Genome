use warnings;
use strict;
use Text::CSV;

#NOTE: Some of the positions in the Gandolfi et al. 2018 table are off by 1 (relative to this table)

my $Gandolfi_supplemental_table = "Supplementary_data_file_2_CatArrayMap.map";
my $GangLi_PostPublication_Mapping_file = "probe_match_GangLi_GitHub.txt";
my $output_folder = "felCat8";

#I've converted the Excel file from the Li et al. 2016 Supplemental Table S1 into separate .csv files (per-chromosome, without "chr" in the name);
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

my %output_hash;

foreach my $output_chr (keys %chr_map_hash){
	my $map_chr = $chr_map_hash{$output_chr};
	my $chr_out = "$output_folder/genetic_map_$output_chr\_felCat8-probe-mapped.txt";
	open($output_hash{$map_chr},"> $chr_out") || die("Could not open $chr_out!");
	print {$output_hash{$map_chr}} "position COMBINED_rate(cM/Mb) Genetic_Map(cM)\n";
}#end foreach my $VCF_chr (@chr_short)

#Gandolfi uses 2X probe names (I believe for felCat2?)
print "Define hash to convert probes\n";

my %probe_hash;

my $line_count=0;
open(INPUT, $GangLi_PostPublication_Mapping_file) || die("Could not open $GangLi_PostPublication_Mapping_file!");
while (<INPUT>){
		my $line = $_;
		chomp $line;
		$line =~ s/\r//g;
		$line =~ s/\n//g;
		$line_count++;
		if($line_count > 1){
			my @line_info = split("\t", $line);
			my $probe_2x = $line_info[0];
			my $probe_felCat6 = $line_info[1];
			my $probe_felCat8 = $line_info[2];
			if($probe_felCat8 =~ /^(chr\w\d)/){
				my ($chr_felCat8) = ($probe_felCat8 =~ /^(chr\w\d)/);
				if(($probe_2x =~ /^$chr_felCat8/)&($probe_felCat6 =~ /^$chr_felCat8/)){
					$probe_hash{$probe_felCat6}=$probe_2x;
				}#end if(($probe_2x =~ /^$chr_felCat8/)&($probe_felCat6 =~ /^$chr_felCat8/))
			}#end if($probe_felCat8 =~ /^(chr\w\d)/)
		}#end if($line_count > 1)
}#end while (<INPUT>)
close(INPUT);

print "Define Li et al. 2016 mapping hash...\n";
my %cM_hash;

foreach my $chr (keys %chr_map_hash){
	my $CSV_chr = $chr;
	$CSV_chr =~ s/chr//g;
	print "$chr|$CSV_chr\n";
	
	#reminded myself how to use the CSV module from https://docs.google.com/file/d/0B1xpw6_kQMKuaElwcTVXcnFmZ1E
	my $csv = Text::CSV->new({ sep_char => ',' });
	
	my $CSV_input = "$CSV_chr.csv";

	$line_count=0;
	open(INPUTCSV, $CSV_input) || die("Could not open $CSV_input!");
	while (<INPUTCSV>){
		my $line = $_;
		chomp $line;
		$line =~ s/\r//g;
		$line =~ s/\n//g;
		$line_count++;
		if($line_count > 1){
			$csv->parse($line);
			my @fields = $csv->fields();
			my $cM = shift @fields;
			
			if (($cM ne "")&($cM ne " ")){
				for (my $i=0; $i < scalar(@fields); $i++){
					if (($fields[$i] ne "")&($fields[$i]ne " ")){
						if(exists($probe_hash{$fields[$i]})){
							my $mappable_ID = $probe_hash{$fields[$i]};
							$cM_hash{$mappable_ID}=$cM;
						}else{
							#print "Skipping probe ID: $fields[$i]\n";
							#exit;
						}
						last;
					}#end if (($fields[$i] ne "")&($fields[$i]ne " "))
				}#end for (my $i=0; $i < scalar(@fields); $i++)
			}#end if ($cM != "")
		}#end if($line_count > 1)
	}#end while (<INPUTCSV>)
	close(INPUTCSV);
}#end foreach my $chr (keys %chr_map_hash)

print "Probes with cM values: ",scalar(keys %cM_hash),"\n";

print "Print probes in Gandolfi et al. 2018 felCat8 position order...\n";

#output files matched to hash in Li et al. 2016 from Gandolfi et al. 2018

#I used this to figure out the 2nd column in the genetic map file format: https://www.biostars.org/p/222697/

my $prev_chr = 0;

my $prev_pos = 0;
my $prev_cM = 0;

my $prev_max_pos = 0;
my $prev_max_cM = 0;

open(INPUT, $Gandolfi_supplemental_table) || die("Could not open $Gandolfi_supplemental_table!");
while (<INPUT>){
		my $line = $_;
		chomp $line;
		$line =~ s/\r//g;
		$line =~ s/\n//g;
		my @line_info = split("\t", $line);
		my $felCat8_chr = $line_info[0];
		my $probeID = $line_info[1];
		my $felCat8_pos = $line_info[3];
		
		if(exists($output_hash{$felCat8_chr})&(exists($cM_hash{$probeID}))){
			my $pos_Mb = $felCat8_pos / 1000000;
			my $cM = $cM_hash{$probeID};
			
			if($felCat8_chr == $prev_chr){
				#next position in same chr
			}else{
				#hopefully, start new chr.  Otherwise, I will have other issues.
				print "Starting genetic mapping file output for chr $felCat8_chr...\n";
				
				$prev_pos = 0;
				$prev_cM = 0;

				$prev_max_pos = 0;
				$prev_max_cM = 0;

				$prev_chr=$felCat8_chr;
			}#end else
			
			if(($cM > $prev_max_cM)&($pos_Mb > $prev_max_pos)){
				#I used this to figure out the 2nd column in the genetic map file format: https://www.biostars.org/p/222697/
				my $combined_rate = ($cM-$prev_cM)/($pos_Mb-$prev_pos);
							
				print {$output_hash{$felCat8_chr}} "$felCat8_pos $combined_rate $cM\n";
							
				$prev_pos = $pos_Mb;
				$prev_cM = $cM;
				if($prev_pos > $prev_max_pos){
					$prev_max_pos=$prev_pos;
				}
				if($prev_cM > $prev_max_cM){
					$prev_max_cM=$prev_cM;
				}
			}
		}#end if(exists($output_hash{$felCat8_chr})&(exists($cM_hash{$probeID})))
	}#end while (<INPUT>)
close(INPUT);
exit;