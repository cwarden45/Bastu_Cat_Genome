use warnings;
use strict;
#use diagnostics;

my $random_seed = 190812;#date - earlier version doesn't explicity consider seed as parameter

my $threads = 16;#I think they are expecting you to run multiple threads per core: I tested this with 8 core / 16 GB RAM without crashing instance (and could have been run locally, if I wasn't waiting for SHAPEIT phasing)
my $SHAPEIT_folder = "../Bastu_basepaws_felCat8_20k/SHAPEIT-FILTERED";
my $genetic_map_folder = "../cat_genetic_map_files/felCat8";
my $test_sample_ID = "basepaws";
my $classes_file = "../Bastu_basepaws_felCat8_20k/Gandolfi_felCat8_plus_Bastu-FILTERED.classes";
my $sample_map_ref = "../Bastu_basepaws_felCat8_20k/Gandolfi_felCat8_plus_Bastu-FILTERED.names";

my $output_folder = "../Bastu_basepaws_felCat8_20k/RFMix_seed$random_seed";
my $sample_map_test = "../Bastu_basepaws_felCat8_20k/test_sample_Bastu.txt";

#assume running within RFMix_v1.5.4
my $RFMix_folder = ".";
my $command = "mkdir $output_folder";
system($command);

print "Create test sample map for file conversion\n";
open(OUT,"> $sample_map_test") || die("Could not open $sample_map_test!");
print OUT "$test_sample_ID\n";
close(OUT);

#preprocessing scripts from https://github.com/armartin/ancestry_pipeline
#assuming this is within the RFMix_v1.5.4 folder (and the script is being run from that folder)
my $Alicia_folder = "ancestry_pipeline";

#previous script only looked at autosomal chromosomes, but you could add in other chromosomes (if you previously processed them) this  way
my @chr_long = ("chrA1","chrA2","chrA3","chrB1","chrB2","chrB3","chrB4","chrC1","chrC2","chrD1","chrD2","chrD3","chrD4","chrE1","chrE2","chrE3","chrF1","chrF2");
my @chr_short = ("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18");

print "Converting files and running RFMix\n";

for (my $i=0; $i < scalar(@chr_long); $i++){
	print "##### Working on chr$chr_short[$i] #####\n";
	##compress .haps file
	print "--> Compressing .haps file (for Alicia's script)...\n";
	my $haps_file = "$SHAPEIT_folder/chr$chr_short[$i]\_phased.haps";
	my $hapsGZ = "$SHAPEIT_folder/chr$chr_short[$i]\_phased.haps.gz";
	
	my $command = "gzip -c $haps_file > $hapsGZ";
	system($command);

	##previous RFMix version file conversion
	print "-->Convert SHAPEIT to RFMix format...\n";
	my $sample_file = "$SHAPEIT_folder/chr$chr_short[$i]\_phased.sample";
	$command = "python $Alicia_folder/shapeit2rfmix.py --shapeit_hap_ref $hapsGZ --shapeit_hap_admixed $hapsGZ --shapeit_sample_ref $sample_file --shapeit_sample_admixed $sample_file --ref_keep $sample_map_ref --admixed_keep $sample_map_test --chr $chr_short[$i] --genetic_map $genetic_map_folder/genetic_map_$chr_long[$i]\_felCat8-probe-mapped.txt --out $output_folder/RFMIX_in";
	system($command);
	
	#create alternative alleles file
	print "-->I think I have the shapeit2rfmix.py input format messed up, so create new .alleles file...\n";
	my $allele_file = "$output_folder/RFMIX_in_chr$chr_short[$i].alleles";
	allele_conversion($haps_file,$allele_file);
	
	##Run RFMix
	print "-->Run RFMix\n";
	my $loc_file = "$output_folder/RFMIX_in_chr$chr_short[$i].snp_locations";
	my $RFmix_out = "$output_folder/chr$chr_short[$i].rfmix";

	#have to run code within RFMix directory
	#remove -e 2 -w 0.2 --use-reference-panels-in-EM: default parameters finished within a couple hours on 16 GB / 4 core computer, but I believe it was stuck on chr1 for 12+ hours with these added
	$command = "python $RFMix_folder/RunRFMix.py --num-threads $threads --forward-backward PopPhased $allele_file $classes_file $loc_file -o $RFmix_out";
	system($command);
}#end for (my $i=0; $i < scalar(@chr_long); $i++)

Viterbi2bed(\@chr_short,$output_folder,$test_sample_ID, $Alicia_folder);

exit;

sub Viterbi2bed{
	my ($arr_ref1, $outputfolder, $ID, $Alicia_folder) =@_;
	
	my @chr_short = @$arr_ref1;

	my $bedA = "$outputfolder/$ID\_A.bed";
	my $bedB = "$outputfolder/$ID\_B.bed";

	my %super_pop_hash;
	$super_pop_hash{1}="K1";
	$super_pop_hash{2}="K2";
	
	open(OUTA,"> $bedA") || die("Could not open $bedA!");
	open(OUTB,"> $bedB") || die("Could not open $bedB!");

	for (my $i=0; $i < scalar(@chr_short); $i++){
		print "##### Convering RFMix Output for chr$chr_short[$i] #####\n";
		my $map_file = "$output_folder/RFMIX_in_chr$chr_short[$i].map";
		my $RFmix_Viterbi = "$output_folder/chr$chr_short[$i].rfmix.0.Viterbi.txt";
		
		my $output_chr = $chr_short[$i];
		if($output_chr eq "X"){
			$output_chr=23;
		}
		
		my $A_start_pos = -1;
		my $A_start_cM = -1;
		my $A_start_Ancestry = "";
		
		my $B_start_pos = -1;
		my $B_start_cM = -1;
		my $B_start_Ancestry = "";

		my $prev_pos = -1;
		my $prev_cM = -1;
		
		my $temp_pos = -1;
		my $temp_cM = -1;
			
		open(MAP,"$map_file") || die("Could not open $map_file!");
		open(VIT,"$RFmix_Viterbi") || die("Could not open $RFmix_Viterbi!");
		
		#code base upon https://stackoverflow.com/questions/2498937/how-can-i-walk-through-two-files-simultaneously-in-perl
		while((my $line1 = <MAP>) and (my $line2 = <VIT>)){
			chomp $line1;
			chomp $line2;
			
			my @line_info1 = split(" ",$line1);
			$temp_pos = $line_info1[0];
			$temp_cM = $line_info1[1];
			my @line_info2 = split(" ",$line2);
			my $A_num = $line_info2[0];
			my $A_status = $super_pop_hash{$A_num};
			my $B_num = $line_info2[1];
			my $B_status = $super_pop_hash{$B_num};
			
			if($A_start_Ancestry eq ""){
				#initialize (or re-initialize) A values
				$A_start_pos=$temp_pos;
				$A_start_cM=$temp_cM;
				$A_start_Ancestry=$A_status;
			}elsif($B_start_Ancestry eq ""){
				#initialize (or re-initialize) B values
				$B_start_pos=$temp_pos;
				$B_start_cM=$temp_cM;
				$B_start_Ancestry=$B_status;
			}elsif($A_status ne $A_start_Ancestry){
				print OUTA "$output_chr\t$A_start_pos\t$prev_pos\t$A_start_Ancestry\t$A_start_cM\t$prev_cM\n";

				$A_start_pos = -1;
				$A_start_cM = -1;
				$A_start_Ancestry = "";
			}elsif($B_status ne $B_start_Ancestry){
				print OUTB "$output_chr\t$B_start_pos\t$prev_pos\t$B_start_Ancestry\t$B_start_cM\t$prev_cM\n";

				$B_start_pos = -1;
				$B_start_cM = -1;
				$B_start_Ancestry = "";
			}

			$prev_pos=$temp_pos;
			$prev_cM=$temp_cM;
		}#end while((my $line1 = <MAP>) and (my $line2 = <VIT>))

		close(MAP);
		close(VIT);
		
		print OUTA "$output_chr\t$A_start_pos\t$prev_pos\t$A_start_Ancestry\t$A_start_cM\t$prev_cM\n";
		print OUTB "$output_chr\t$B_start_pos\t$prev_pos\t$B_start_Ancestry\t$B_start_cM\t$prev_cM\n";
		
	}#end for (my $i=0; $i < scalar(@chr_long); $i++)

	close(OUTA);
	close(OUTB);

	print "Plotting Karyogram (based upon Alicia's script)\n";
	my $plotPNG = "$outputfolder/$ID.png";	
	my $command = "python $Alicia_folder/plot_karyogram.py --bed_a $bedA --bed_b $bedB --ind $ID --out $plotPNG --pop_order K1,K2 --colors blue,orange";
	system($command);
}#end def Viterbi2bed

sub allele_conversion
	{
		my ($inputfile, $outputfile) =@_;
		
		open(OUT,"> $outputfile") || die("Could not open $outputfile!");

		open(IN,"$inputfile") || die("Could not open $inputfile!");
		while (<IN>){
			my $line = $_;
			chomp $line;
			my @line_info = split(" ",$line);
			shift(@line_info);
			shift(@line_info);
			shift(@line_info);
			shift(@line_info);
			shift(@line_info);
			print OUT join("",@line_info),"\n";
		}#end while (<IN>)
		close(IN);
		close(OUT);
	}#end def allele_conversion
