use warnings;
use strict;
use diagnostics;
use Bio::SeqIO;

my $outputVCF = "Gandolfi_felCat9.vcf";
my $outputPED = "Gandolfi_felCat9.ped";

my $felCat9_map =  "Gandolfi_felCat9.map";#created by create_felCat9_map_from_probe_BLAST.R
my $refFa = "felCat9.fa";

my $providedPed = "Supplemetary_data_file_5_CatArrayData.ped"; #62,272 markers
my $providedMap = "Supplementary_data_file_2_CatArrayMap.map";

print "Create hash for felCat9 mapping and strand mapping...\n";

my %felCat9_map_hash;

open(STRAND, $felCat9_map) || die("Could not open $felCat9_map!");

while (<STRAND>){
	my $line = $_;
	chomp $line;
	$line =~ s/\r//g;
	my @line_info = split("\t",$line);
	my $snpID = $line_info[0];
	my $felCat9_chr = $line_info[1];

	shift @line_info;

	if($felCat9_chr eq "chrX"){
		$felCat9_map_hash{$snpID}= join("\t",@line_info);
	}elsif($felCat9_chr =~ /chr\w\d$/){
		$felCat9_map_hash{$snpID}= join("\t",@line_info);
	}
}#end while (<STRAND>)

close(STRAND);

my %geno_hash;

open(VCFOUT, ">$outputVCF") || die("Could not open $outputVCF!");
open(PEDOUT, ">$outputPED") || die("Could not open $outputPED!");

print "Creating separate .ped file and genotype hash...\n";
open(PEDIN, $providedPed) || die("Could not open $providedPed!");

print VCFOUT "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT";

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
	
	if($sampleID eq "Cinnamon"){
		$pheno="Abyssinian";
	}elsif($sampleID =~ /^FSI/){
		$pheno="Wildcat";
	}elsif($sampleID =~ /^SFold/){
		$pheno="ScottishFold";
	}elsif($sampleID =~ /^CR/){
		#Cornish Rex (CREX)?
		$pheno="CR";
	}elsif($sampleID =~ /^CT/){
		#Chartreux (CHR)?
		$pheno="CT";
	}elsif($sampleID eq "Zeelie"){
		$pheno="Zeelie";
	}elsif($sampleID eq "Speedy"){
		$pheno="Speedy";
	}elsif(($sampleID =~ /^SRX/)|($sampleID =~ /^srx/)){
		$pheno="SRX";
	}elsif($sampleID =~ /^Pbe/){
		$pheno="PBE";
	}elsif($sampleID =~ /^CNPR/){
		$pheno="CNPR";
	}elsif($sampleID =~ /^CNPN/){
		$pheno="CNPN";
	}elsif($sampleID =~ /^HK/){
		$pheno="HK";
	}elsif($sampleID =~ /^LYM/){
		$pheno="LYM";
	}elsif($sampleID =~ /^Phir-/){
		$pheno="Phir";
	}elsif($sampleID =~ /^WGA/){
		$pheno="WGA";
	}elsif($sampleID =~ /^RVP/){
		$pheno="RVP";
	}elsif($sampleID =~ /^meurs/){
		$pheno="MEURS";
	}elsif(($sampleID =~ /^Fcat-/)|($sampleID =~ /^FCA/)|($sampleID =~ /^Fca/)|($sampleID =~ /^\d+/)){
		#intentionially allow call things like 6233T and 4346II as "Unknown"
		$pheno="Unknown";
	}else{
		print "Add code to parse $sampleID\n";
		exit;
	}#else else
	
	print PEDOUT "$famID\t$sampleID\t$matID\t$patID\t$gender\t$pheno\n";
	print VCFOUT "\t$sampleID";
	for (my $i=0; $i < scalar(@line_info); $i++){
		#still needs to be converted, but provide genotypes
		if(exists($geno_hash{$i})){
			$geno_hash{$i}=$geno_hash{$i}."\t".$line_info[$i]
		}else{
			$geno_hash{$i}=$line_info[$i]
		}#end else

	}#end for (my $i=0; $i < scalar(@line_info); $i++)
}#end while (<PEDIN>)

close(PEDIN);
close(PEDOUT);

print scalar(keys %geno_hash)," markers\n";

print VCFOUT "\n";

print "Create reference sequence hash...\n";

my %ref_hash;

my $inseq = Bio::SeqIO->new(-file   => $refFa,
                            -format => "fasta");

while (my $seq = $inseq->next_seq) {
	my $chr_name = $seq->id;
	if(($chr_name eq "chrX") | ($chr_name =~ /chr\w\d$/)){
		my $chr_seq = $seq->seq;
		$ref_hash{$chr_name}=$chr_seq;
		print "$chr_name: ".length($chr_seq)." nucleotides\n";
	}#end if(exists($chr_map_hash{$chr_name}))
}#end while (my $seq = $inseq->next_seq) 

print "Create separate .vcf file..\n";

#still use this for plink
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

open(MAPIN, $providedMap) || die("Could not open $providedMap!");

my $line_count = 0;

my $matching_genotype_counts = 0;
my $matching_genotype_counts_minus = 0;

while (<MAPIN>){
	my $line = $_;
	chomp $line;
	my @line_info = split("\t",$line);
	my $felCat8_chr = $line_info[0];
	my $snpID = $line_info[1];
	my $felCat8_pos1 = $line_info[3];
		
	if(exists($felCat9_map_hash{$snpID})){
		my $var_text = $felCat9_map_hash{$snpID};
		my @var_info = split("\t", $var_text);
		my $felCat9_chr = $var_info[0];
		my $felCat9_pos = $var_info[1];
		my $felCat9_ref = $var_info[2];
		my $felCat9_var = $var_info[3];
		my $felCat9_strand = $var_info[4];
		
		if(!exists($ref_hash{$felCat9_chr})){
			print "Problem mapping $felCat9_chr!\n";
			print "|$felCat9_chr|$felCat9_pos|$felCat9_ref|$felCat9_var|$felCat9_strand|\n";
			print "$line\n";
			exit;
		}
		my $chr_seq = $ref_hash{$felCat9_chr};
		my $ref_nuc = uc(substr($chr_seq, $felCat9_pos+1, 1));
		
		my $geno_text = $geno_hash{$line_count};
		#print "|$felCat9_strand|\n";
		
		if($felCat9_strand eq "-"){
			#use reverse complement, but you don't actually have to reverse sequence (in fact, that would mess up the results if you did)
			#otherwise, copied from https://gist.github.com/dnatag4snippet/4624375
			$geno_text =~ tr/ATGCatgc/TACGtacg/;
			$felCat9_ref =~ tr/ATGCatgc/TACGtacg/;
			$felCat9_var =~ tr/ATGCatgc/TACGtacg/;
		}#end if($strand_hash{$snpID} eq "-")

		#if($ref_nuc ne $felCat9_ref){
		#	print "Error in reference sequence for $ref_nuc versus $felCat9_ref?\n";
		#	print "|$felCat9_chr|$felCat9_pos|$felCat9_ref|$felCat9_var|$felCat9_strand|\n";
		#	print "$line\n";
		#	exit;
		#}

		$geno_text =~ s/ //g;
		my @geno_arr = split("\t",$geno_text);
		
		$geno_text =~ s/$ref_nuc//g;
		my $ALT = "";
		if ($geno_text =~ /A/){
			$ALT = $ALT."A";
		}
		if ($geno_text =~ /T/){
			$ALT = $ALT."T";
		}
		if ($geno_text =~ /G/){
			$ALT = $ALT."G";
		}
		if ($geno_text =~ /C/){
			$ALT = $ALT."C";
		}
		
		my $ref_bool = 0;
		if(($ref_nuc eq $felCat9_ref) and ($ALT eq $felCat9_var)){
			$ref_bool = 1;
		}
		my $alt_bool = 0;
		if(($ALT eq $felCat9_ref) and ($ref_nuc eq $felCat9_var)){
			$alt_bool = 1;
		}
		
		if(($ref_bool == 1) | ($alt_bool == 1)){
			$matching_genotype_counts++;
			if($felCat9_strand eq "-"){
				$matching_genotype_counts_minus++;
			}#end if($strand_hash{$snpID} eq "-")
			
			my $num_chr =$chr_map_hash{$felCat9_chr};
			if(!exists($chr_map_hash{$felCat9_chr})){
				print "Problem mapping number for $felCat9_chr\n";
				exit;
			}
			
			print VCFOUT "$num_chr\t$felCat9_pos\t$snpID\t$ref_nuc\t$ALT\t.\tPASS\t.\tGT";
					
			for (my $j=0; $j < scalar(@geno_arr); $j++){
				
				my $temp_geno = $geno_arr[$j];
				
				if(length($temp_geno) != 2){
					print VCFOUT "\t./.";
				}else{
					$temp_geno =~ s/$ref_nuc/0/;
					my $allele1 = substr($temp_geno,0,1);
					if($allele1 ne "0"){
						$allele1 = 1;
					}
					my $allele2 = substr($temp_geno,1,1);
					if($allele2 ne "0"){
						$allele2 = 1;
					}
					print VCFOUT "\t$allele1/$allele2";
				}
			}#end for (my $j=0; $i < scalar(); $j++)
					
			print VCFOUT "\n";			
		}#end if($ALT eq $felCat9_var)
	}#end if(exists($felCat9_map_hash{$snpID}))
	
	$line_count++;
}#end while (<MAPIN>)

close(MAPIN);

close(VCFOUT);

print "Reference Match and Exactly 1 Alternate Allele: $matching_genotype_counts\n";
print "Reference Match and Exactly 1 Alternate Allele (Reversed): $matching_genotype_counts_minus\n";

exit;
