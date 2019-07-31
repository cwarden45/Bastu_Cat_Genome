use warnings;
use strict;
use diagnostics;

#2,012,348 probes (number of lines, minus one)

my $threads = 4;
my $sample_name = "basepaws";
my $SHAPEIT_chr_folder = "SHAPEIT";
my $inputVCF="../../../../Bastu_Genome/Cat_SNP_Chip/Gandolfi_felCat8_plus_Bastu.vcf";

my @chr_long = ("chrA1","chrA2","chrA3","chrB1","chrB2","chrB3","chrB4","chrC1","chrC2","chrD1","chrD2","chrD3","chrD4","chrE1","chrE2","chrE3","chrF1","chrF2");
my @chr_short = ("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18");

my $SHAPEIT_binary = "/opt/SHAPEIT/shapeit.v2.904.3.10.0-693.11.6.el7.x86_64/bin/shapeit";
my $plink_binary = "/opt/plink/plink2";

my $map_folder = "../cat_genetic_map_files/uncertain";

my $command = "mkdir $SHAPEIT_chr_folder";
system($command);

my %output_hash;

foreach my $VCF_chr (@chr_short){
	my $chr_VCF_out = "$SHAPEIT_chr_folder/chr$VCF_chr\_input.vcf";
	open($output_hash{$VCF_chr},"> $chr_VCF_out") || die("Could not open $chr_VCF_out!");
}#end foreach my $VCF_chr (@chr_short)

my $line_count=0;
open(INPUTFILE, $inputVCF) || die("Could not open $inputVCF!");
while (<INPUTFILE>){
	$line_count++;
	my $line = $_;

	my @line_info = split("\t",$line);
	my $chr = $line_info[0];

	if($line_count == 1){
		foreach my $temp_chr (@chr_short){
			print {$output_hash{$temp_chr}} "$line";
		}#end foreach my $temp_chr (@chr_short)
	}else{
		
		if(exists($output_hash{$chr})){
			print {$output_hash{$chr}} $line;
		}#end if(exists($output_hash{$chr}))
	}#end else
}#end while (<INPUTFILE>)
			
close(INPUTFILE);


###run similar code for autosomal chromosomes
for (my $i=0; $i < 18; $i++){
	my $VCF_IN = "$SHAPEIT_chr_folder/chr".$chr_short[$i]."_input.vcf";
	my $MAP = "$map_folder/genetic_map_".$chr_long[$i]."_felCat8-from-felCat6.txt";
	
	my $IN_Prefix = "$SHAPEIT_chr_folder/chr".$chr_short[$i]."_input";
	my $command = "$plink_binary --vcf $VCF_IN --make-bed --out $IN_Prefix";
	system($command);
	
	my $OUT_Prefix = "$SHAPEIT_chr_folder/chr".$chr_short[$i]."_phased";
	$command = "$SHAPEIT_binary --input-bed $IN_Prefix.bed $IN_Prefix.bim $IN_Prefix.fam -M $MAP -O $OUT_Prefix --thread $threads --force";
	system($command);
	
	my $VCF_OUT = "$SHAPEIT_chr_folder/chr".$chr_short[$i]."_phased.vcf";
	$command = "$SHAPEIT_binary -convert --input-haps $OUT_Prefix --output-vcf $VCF_OUT";
	system($command);
}#end for (my $i=0; $i < scalar(@chr_long); $i++)

exit;