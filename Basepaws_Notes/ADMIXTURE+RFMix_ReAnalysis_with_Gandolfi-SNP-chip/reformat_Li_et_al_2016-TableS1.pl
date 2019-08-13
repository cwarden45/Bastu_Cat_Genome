use warnings;
use strict;
use Text::CSV;

#NOTE: Please be aware that this will only work for felCat6

my $Gandolfi_supplemental_table = "Supplementary_data_file_2_CatArrayMap.map";
my $output_folder = "uncertain";

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
	#my $map_chr = $chr_map_hash{$output_chr};
	my $chr_out = "$output_folder/genetic_map_$output_chr\_felCat6.txt";
	open($output_hash{$output_chr},"> $chr_out") || die("Could not open $chr_out!");
	print {$output_hash{$output_chr}} "position COMBINED_rate(cM/Mb) Genetic_Map(cM)\n";
}#end foreach my $VCF_chr (@chr_short)

foreach my $chr (keys %chr_map_hash){
	my $CSV_chr = $chr;
	$CSV_chr =~ s/chr//g;
	print "$chr|$CSV_chr\n";
	
	#reminded myself how to use the CSV module from https://docs.google.com/file/d/0B1xpw6_kQMKuaElwcTVXcnFmZ1E
	my $csv = Text::CSV->new({ sep_char => ',' });
	
	my $CSV_input = "$CSV_chr.csv";

	my $prev_pos = 0;
	my $prev_cM = 0;

	my $prev_max_pos = 0;
	my $prev_max_cM = 0;

	my $line_count=0;
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
						my $probe_text = $fields[$i];
						my ($probe_chr,$probe_pos) = ($probe_text =~ /(.*)\.(\d+)$/);
						my $pos_Mb = $probe_pos / 1000000;
						
						if(($probe_chr eq $chr)&($cM > $prev_max_cM)&($pos_Mb > $prev_max_pos)){
							#I used this to figure out the 2nd column in the genetic map file format: https://www.biostars.org/p/222697/
							my $combined_rate = ($cM-$prev_cM)/($pos_Mb-$prev_pos);
							
							print {$output_hash{$chr}} "$probe_pos $combined_rate $cM\n";
							
							my $prev_pos = $pos_Mb;
							my $prev_cM = $cM;
							if($prev_pos > $prev_max_pos){
								$prev_max_pos=$prev_pos;
							}
							if($prev_cM > $prev_max_cM){
								$prev_max_cM=$prev_cM;
							}
						}
						last;
					}#end if (($fields[$i] ne "")&($fields[$i]ne " "))
				}#end for (my $i=0; $i < scalar(@fields); $i++)
			}#end if ($cM != "")
		}#end if($line_count > 1)
	}#end while (<INPUTCSV>)
	close(INPUTCSV);
}#end foreach my $chr (keys %chr_map_hash)

exit;
