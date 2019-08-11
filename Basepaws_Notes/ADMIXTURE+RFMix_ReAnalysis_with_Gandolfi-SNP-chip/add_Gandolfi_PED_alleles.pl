use warnings;
use strict;
use diagnostics;

my $vcfIN = "Cinnamon_felCat8_array-matched.vcf";
my $output_file = "Cinnamon_felCat8_array-matched-PLUS_S5_values.txt";
my $providedPed = "../Cat_SNP_Chip/Supplemetary_data_file_5_CatArrayData.ped"; #62,272 markers

#find sequences for two versions of Cinnamon SNP chip
print "Creating genotype hash..\n";
open(PEDIN, $providedPed) || die("Could not open $providedPed!");

my %geno_hash;

my $extra_output_header = "";

while (<PEDIN>){
	my $line = $_;
	chomp $line;
	my @line_info = split("\t",$line);
	my $famID = shift(@line_info);
	my $sampleID = shift(@line_info);
	my $matID = shift(@line_info);
	my $patID = shift(@line_info);
	my $gender = shift(@line_info);
	my $pheno = shift(@line_info);
	
	if(($sampleID eq "Cinnamon")|($sampleID eq "WGA12682")){
		$extra_output_header="$extra_output_header\t$sampleID.array";
		
		for (my $i=0; $i < scalar(@line_info); $i++){
			#still needs to be converted, but provide genotypes
			my $geno = $line_info[$i];
			$geno =~ s/ //g;
			if(exists($geno_hash{$i})){
				$geno_hash{$i}=$geno_hash{$i}."\t$geno";
			}else{
				$geno_hash{$i}="\t$geno";
			}#end else

	}#end for (my $i=0; $i < scalar(@line_info); $i++)		
	}#end if(($sampleID eq "Cinnamon")|($sampleID eq "WGA12682"))
}#end while (<PEDIN>)

close(PEDIN);

#add SNP chip data to WGS .vcf
print "Adding SNP chip data to help map other cats...\n";

open(OUTPUTFILE, ">$output_file") || die("Could not open $output_file!");

my $content_line_count=0;

open(INPUTFILE, $vcfIN) || die("Could not open $vcfIN!");
while (<INPUTFILE>){
	my $line = $_;
	chomp $line;


	if($line =~ /^#CHROM/){
		print OUTPUTFILE "$line$extra_output_header\n";
	}elsif(!($line =~ /^#/)){
		if(exists($geno_hash{$content_line_count})){
			my $extra_info = $geno_hash{$content_line_count};
			print OUTPUTFILE "$line$extra_info\n";
		}else{
			print "Problem adding genotype to line $$content_line_count\n";
			exit;
		}
		
		$content_line_count++;
	}#end if(!($line =~ /^#/))
}#end while (<INPUTFILE>)
			
close(INPUTFILE);

close(OUTPUTFILE);

exit;