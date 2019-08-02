use warnings;
use strict;
use diagnostics;

#requiring a probability of 0.90 results in 865 reference samples

my $input_ADMIXTURE="../../../../Bastu_Genome/Cat_SNP_Chip/Gandolfi_felCat8_plus_Bastu.2.Q";
my $outout_classes = "Gandolfi_felCat8_plus_Bastu-FILTERED.classes";
my $sample_map_ref = "Gandolfi_felCat8_plus_Bastu-FILTERED.names";

my $SHAPEIT_IN = "SHAPEIT";
my $SHAPEIT_OUT = "SHAPEIT-FILTERED";
my $test_index = 2079;

my $command = "mkdir $SHAPEIT_OUT";
system($command);

#create .classes file
my @output_index = ($test_index);

open(CLASS,"> $outout_classes") || die("Could not open $outout_classes!");

my $output_text = "";

my %ped_sample_outputhash;
$ped_sample_outputhash{$test_index+2}=1;

my $line_count = 0;
open(ADMIXTURE,"$input_ADMIXTURE") || die("Could not open $input_ADMIXTURE!");
while (<ADMIXTURE>){
	my $line = $_;
	chomp $line;
	my @line_info = split(" ",$line);
	my $Pr_K1 = $line_info[0];
	my $Pr_K2 = $line_info[1];
	
	$line_count++;
	
	if ($Pr_K1 > 0.9){
		unshift(@output_index,$line_count);
		$ped_sample_outputhash{$line_count+2}=1;
		#print join("|",@output_index),"\n";
		if($output_text eq ""){
			$output_text="1\t1";
		}else{
			$output_text=$output_text."\t1\t1";
		}
	}#end if ($Pr_K1 > 0.9)
	
	if ($Pr_K2 > 0.9){
		unshift(@output_index,$line_count);
		$ped_sample_outputhash{$line_count+2}=1;
		#print join("|",@output_index),"\n";
		if($output_text eq ""){
			$output_text="2\t2";
		}else{
			$output_text=$output_text."\t2\t2";
		}
	}#end if ($Pr_K1 > 0.9)
}#end while (<ADMIXTURE>)
close(ADMIXTURE);

$output_text = $output_text."\t0\t0\n";
print CLASS $output_text;
close(CLASS);

#create filtered .vcf files
print "Output VCFs with ",scalar(@output_index)," samples (references and test sample)...\n";

open(NAMES,"> $sample_map_ref") || die("Could not open $sample_map_ref!");

for (my $i=1; $i <= 18; $i++){
	my $VCF_IN = "$SHAPEIT_IN/chr$i\_phased.vcf";
	my $VCF_OUT = "$SHAPEIT_OUT/chr$i\_phased.vcf";
	
	open(OUT,"> $VCF_OUT") || die("Could not open $VCF_OUT!");

	open(IN,"$VCF_IN") || die("Could not open $VCF_IN!");
	while (<IN>){
		my $line = $_;
		chomp $line;
		
		if ($line =~ /^##/){
			print OUT "$line\n";
		}else{
			my @line_info = split("\t",$line);
			my $CHROM= shift @line_info;
			my $POS= shift @line_info;
			my $ID= shift @line_info;
			my $REF= shift @line_info;
			my $ALT= shift @line_info;
			my $QUAL= shift @line_info;
			my $FILTER= shift @line_info;
			my $INFO=shift @line_info;
			my $FORMAT= shift @line_info;
			
			print OUT "$CHROM\t$POS\t$ID\t$REF\t$ALT\t$QUAL\t$FILTER\t$INFO\t$FORMAT";
			for (my $j=0; $j < scalar(@output_index); $j++){
				my $index = $output_index[$j];
				print OUT "\t".$line_info[$index-1];
				
				if (($CHROM eq "#CHROM")&($j+1 != scalar(@output_index))){
					print NAMES $line_info[$index-1],"\n";
				}#end if (($CHROM eq "#CHROM")&($j+1 != scalar(@output_index)))
			}#end for (my $j=0; $j < scalar(@output_index); $j++)
			print OUT "\n";
		}#end else
	}#end while (<IN>)
	close(IN);
	
	close(OUT);
}#end for (my $i=0; $i < scalar(); $i++)

close(NAMES);

print "Output .ped / .sample files with ",scalar(@output_index)," samples (references and test sample)...\n";

for (my $i=1; $i <= 18; $i++){
	my $sample_IN = "$SHAPEIT_IN/chr$i\_phased.sample";
	my $sample_OUT = "$SHAPEIT_OUT/chr$i\_phased.sample";
	
	open(OUT,"> $sample_OUT") || die("Could not open $sample_OUT!");

	$line_count = 0;

	open(IN,"$sample_IN") || die("Could not open $sample_IN!");
	while (<IN>){
		my $line = $_;
		chomp $line;
		
		$line_count++;
		
		if (($line_count <=2)|(exists($ped_sample_outputhash{$line_count}))){
			print OUT "$line\n";
		}
	}#end while (<IN>)
	close(IN);
	
	close(OUT);
}#end for (my $i=0; $i < scalar(); $i++)

print "Output .haps files with ",scalar(@output_index)," samples (references and test sample)...\n";

for (my $i=1; $i <= 18; $i++){
	my $VCF_IN = "$SHAPEIT_IN/chr$i\_phased.haps";
	my $VCF_OUT = "$SHAPEIT_OUT/chr$i\_phased.haps";
	
	open(OUT,"> $VCF_OUT") || die("Could not open $VCF_OUT!");

	open(IN,"$VCF_IN") || die("Could not open $VCF_IN!");
	while (<IN>){
		my $line = $_;
		chomp $line;
		
		if ($line =~ /^##/){
			print OUT "$line\n";
		}else{
			my @line_info = split(" ",$line);
			my $CHROM= shift @line_info;
			my $ID= shift @line_info;
			my $POS= shift @line_info;
			my $REF= shift @line_info;
			my $ALT= shift @line_info;
			
			print OUT "$CHROM $ID $POS $REF $ALT";
			foreach my $index (@output_index){
				my $allele1 = $line_info[2 * $index-1-1];
				my $allele2 = $line_info[2 * $index-1];
				print OUT " $allele1 $allele2"
			}#end foreach my $index (@output_index)
			print OUT "\n";
		}#end else
	}#end while (<IN>)
	close(IN);
	
	close(OUT);
}#end for (my $i=0; $i < scalar(); $i++)

exit;