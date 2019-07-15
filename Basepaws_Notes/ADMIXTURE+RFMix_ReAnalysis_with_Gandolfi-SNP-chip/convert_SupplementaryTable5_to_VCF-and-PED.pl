use warnings;
use strict;
use diagnostics;
use Bio::SeqIO;

#my $refFa = "felCat6.fa"; #SNP name? (however, if that is correct, then that would mean Table4 from 41598_2018_25438_MOESM4_ESM_Full-Mapping-Tab, can only correct the strand for felCat8)
#my $outputVCF = "Gandolfi_felCat6.vcf";
#my $outputPED = "Gandolfi_felCat6.ped";

my $refFa = "felCat8.fa"; #position?
my $outputVCF = "Gandolfi_felCat8.vcf";
my $outputPED = "Gandolfi_felCat8.ped";


my $providedPed = "Supplemetary_data_file_5_CatArrayData.ped"; #62,272 markers
my $providedMap = "Supplementary_data_file_2_CatArrayMap.map";
my $providedStrand = "41598_2018_25438_MOESM4_ESM_Full-Mapping-Table4.txt";

print "Checking supplemental table for strand mappings...\n";

my %strand_hash;

open(STRAND, $providedStrand) || die("Could not open $providedStrand!");

while (<STRAND>){
	my $line = $_;
	chomp $line;
	my @line_info = split("\t",$line);
	my $snpID = $line_info[0];
	my $ref_hit = $line_info[2];
	
	if(($ref_hit ne "*")&($ref_hit ne "0")&($ref_hit ne "#VALUE!")){
		#I'm losing some posiitions due to Excel formatting (prior to export), but I think that's OK if it's only a few
		if ($ref_hit =~ /^\+/){
			$strand_hash{$snpID}="+";
		}elsif($ref_hit =~ /^-/){
			$strand_hash{$snpID}="";
		}else{
			print "Error parsing hit strand information: $snpID --> $ref_hit in $line\n";
			exit;
		}
		
	}#end if($ref_hit ne "*")
}#end while (<STRAND>)

close(STRAND);

my %geno_hash;

open(VCFOUT, ">$outputVCF") || die("Could not open $outputVCF!");
open(PEDOUT, ">$outputPED") || die("Could not open $outputPED!");

print "Creating separate .ped file and genotype hash...\n";
open(PEDIN, $providedPed) || die("Could not open $providedPed!");

print VCFOUT "CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT";

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

my %ref_hash;

my $inseq = Bio::SeqIO->new(-file   => $refFa,
                            -format => "fasta");

while (my $seq = $inseq->next_seq) {
	my $chr_name = $seq->id;
	if(exists($chr_map_hash{$chr_name})){
		my $chr_alt = $chr_map_hash{$chr_name};
		my $chr_seq = $seq->seq;
		$ref_hash{$chr_alt}=$chr_seq;
		print "$chr_name --> $chr_alt: ".length($chr_seq)." nucleotides\n";
	}#end if(exists($chr_map_hash{$chr_name}))
}#end while (my $seq = $inseq->next_seq) 

print "Create separate .vcf file..\n";

open(MAPIN, $providedMap) || die("Could not open $providedMap!");

my $line_count = 0;

while (<MAPIN>){
	my $line = $_;
	chomp $line;
	my @line_info = split("\t",$line);
	my $chr1 = $line_info[0];
	my $snpID = $line_info[1];
	my $pos1 = $line_info[3];
	
	my ($chr2,$pos2) = ($snpID =~ /(.*)\.(\d+)/);
	my $altID="$chr1:$pos1";
	
	#if(exists($chr_map_hash{$chr2})){
	#	my $chr_num = $chr_map_hash{$chr2};	
	#	if($chr_num  <= 19){
		
		if(($chr1  <= 19)&(exists($strand_hash{$snpID}))){	
			my $chr_seq = $ref_hash{$chr1};
			if($pos1 < length($chr_seq)){
				my $ref_nuc = uc(substr($chr_seq, $pos1+1, 1));
				#if(!exists($ref_hash{$chr_num})){
				#	print "Not  able to get sequence for chr '$chr_num'\n";
				#}#endif(!exists($ref_hash{$chr_num}))
				#my $chr_seq = $ref_hash{$chr_num};
				#my $ref_nuc = substr($chr_seq, $pos2+1, 1);
				
				my $geno_text = $geno_hash{$line_count};
				if($strand_hash{$snpID} eq "-"){
					#use reverse complement, but you don't actually have to reverse sequence (in fact, that would mess up the results if you did)
					#otherwise, copied from https://gist.github.com/dnatag4snippet/4624375
					$geno_text =~ tr/ATGCatgc/TACGtacg/;
				}#end if($strand_hash{$snpID} eq "-")
				
				$geno_text =~ s/$ref_nuc//g;
				$geno_text =~ s/ //g;
				
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
				
				#if(length($ALT) > 1){
				#	print "Error with genotypes in $line\n";
				#	print "Is $ref_nuc the correct reference sequence?\n";
				#	exit;
				#}#end if(length($ALT > 1))
				
				if($ALT ne ""){
					print VCFOUT "$chr1\t$pos1\t$snpID\t$ref_nuc\t$ALT\t.\tPASS\t.\tGT";
					#print VCFOUT "$chr2\t$pos2\t$altID\t$ref_nuc\t$ALT\t.\tPASS\t.\tGT";
					
					my @geno_arr = split("\t",$geno_text);
					
					#for (my $j=0; $j < scalar(@geno_arr); $j++){
					for (my $j=0; $j < 10; $j++){
						print VCFOUT "\t".$geno_arr[$j];
					}#end for (my $j=0; $i < scalar(); $j++)
					
					print VCFOUT "\n";				
				}else{
					print "Skipping $line due to empty reference allele..\n";
				}
			}else{
				print "Skipping line because it is beyond chromosome boundary:\n";
				print "$line\n";
			}#end else
			
		}#end if($chr1  <= 19)
		
	#}#end if($chr_map_hash{$chr2})
	
	$line_count++;
}#end while (<MAPIN>)

close(MAPIN);

close(VCFOUT);

exit;