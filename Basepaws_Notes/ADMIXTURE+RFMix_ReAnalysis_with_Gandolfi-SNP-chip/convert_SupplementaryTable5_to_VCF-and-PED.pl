use warnings;
use strict;
use diagnostics;
use Bio::SeqIO;

my $outputVCF = "Gandolfi_felCat8.vcf";
my $outputPED = "Gandolfi_felCat8.ped";

my $probe_seq_table =  "41598_2018_25438_MOESM4_ESM_Full-Mapping-Table4.txt";
my $refFa = "felCat8.fa";
my $providedPed = "Supplemetary_data_file_5_CatArrayData.ped"; #62,272 markers
my $providedMap = "Supplementary_data_file_2_CatArrayMap.map";

print "Create hash for felCat8 strand and probe seqs...\n";

my %felCat8_seq_hash;

open(STRAND, $probe_seq_table) || die("Could not open $probe_seq_table!");

while (<STRAND>){
	my $line = $_;
	chomp $line;
	$line =~ s/\r//g;
	my @line_info = split("\t",$line);
	my $snpID = $line_info[0];
	my $ref_hit = $line_info[2];
	my $genoIDs = $line_info[7];
	my $refNuc = $line_info[8];
	
	if(($ref_hit ne "*")&($refNuc ne "*")&($ref_hit ne "0")&($ref_hit ne "#VALUE!")){
		
		$genoIDs =~ s/\[//;
		$genoIDs =~ s/\///;
		$genoIDs =~ s/\]//;

		$refNuc =~ s/\[//;
		$refNuc =~ s/\]//;
	
		#I'm losing some posiitions due to Excel formatting (prior to export), but I think that's OK if it's only a few
		if ($ref_hit =~ /^\+/){
			$genoIDs =~ s/$refNuc//;
			$felCat8_seq_hash{$snpID}="$refNuc\t$genoIDs\t+";
		}elsif($ref_hit =~ /^-/){
			$refNuc =~ tr/ATGCatgc/TACGtacg/;
			$genoIDs =~ s/$refNuc//;
			$felCat8_seq_hash{$snpID}="$refNuc\t$genoIDs\t-";
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

my $matching_genotype_counts = 0;
my $matching_genotype_counts_minus = 0;

while (<MAPIN>){
	my $line = $_;
	chomp $line;
	my @line_info = split("\t",$line);
	my $felCat8_chr = $line_info[0];
	my $snpID = $line_info[1];
	my $felCat8_pos = $line_info[3];
		
	if(($felCat8_chr <= 19) & (exists($felCat8_seq_hash{$snpID}))){
		my $var_text = $felCat8_seq_hash{$snpID};
		my @var_info = split("\t", $var_text);
		my $felCat8_ref = $var_info[0];
		my $felCat8_var = $var_info[1];
		my $felCat8_strand = $var_info[2];
		
		my $chr_seq = $ref_hash{$felCat8_chr};
		my $ref_nuc = uc(substr($chr_seq, $felCat8_pos+1, 1));
		
		my $geno_text = $geno_hash{$line_count};
		#print "|$felCat9_strand|\n";
		
		if($felCat8_strand eq "-"){
			#use reverse complement, but you don't actually have to reverse sequence (in fact, that would mess up the results if you did)
			#otherwise, copied from https://gist.github.com/dnatag4snippet/4624375
			$geno_text =~ tr/ATGCatgc/TACGtacg/;
			$felCat8_ref =~ tr/ATGCatgc/TACGtacg/;
			$felCat8_var =~ tr/ATGCatgc/TACGtacg/;
		}#end if($strand_hash{$snpID} eq "-")

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
		if(($ref_nuc eq $felCat8_ref) and ($ALT eq $felCat8_var)){
			$ref_bool = 1;
		}
		my $alt_bool = 0;
		if(($ALT eq $felCat8_ref) and ($ref_nuc eq $felCat8_var)){
			$alt_bool = 1;
		}
		
		if(($ref_bool == 1) | ($alt_bool == 1)){
			$matching_genotype_counts++;
			if($felCat8_strand eq "-"){
				$matching_genotype_counts_minus++;
			}#end if($strand_hash{$snpID} eq "-")
				
			print VCFOUT "$felCat8_chr\t$felCat8_pos\t$snpID\t$ref_nuc\t$ALT\t.\tPASS\t.\tGT";
					
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
		}#end 
	}#end if(exists($felCat8_map_hash{$snpID}))
	
	$line_count++;
}#end while (<MAPIN>)

close(MAPIN);

close(VCFOUT);

print "Reference Match and Exactly 1 Alternate Allele: $matching_genotype_counts\n";
print "Reference Match and Exactly 1 Alternate Allele (Reversed): $matching_genotype_counts_minus\n";

exit;
