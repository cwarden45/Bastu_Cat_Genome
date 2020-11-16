use warnings;
use strict;

my $inputfolder = "../Reads";
my $barcode_seqs = "barcodes.txt";

#modified from https://github.com/cwarden45/Bastu_Cat_Genome/blob/master/Basepaws_Notes/Read_QC/parse_FASTQ_reads.pl

open(BARCODE, "> $barcode_seqs") || die("Could not open $barcode_seqs!");

print BARCODE "Sample\tI1.Barcode\tI1.Name\tI2.Barcode\tI2.Name\tRead.Count\n";

#Found with FastQC
my $Nextera_transposase_seq = "CTGTCTCTTATA";
my $Nextera_transposase_revcom = "TATAAGAGACAG";

#from https://support.illumina.com/content/dam/illumina-support/documents/documentation/chemistry_documentation/experiment-design/illumina-adapter-sequences-1000000002694-09.pdf
#remember, I2(i7) is actually closer to R1, I2(i5) is closer to R2
my $I1_primer = "CAAGCAGAAGACGGCATACGAGAT";
my $I1_primer_revcom = "ATCTCGTATGCCGTCTTCTGCTTG";
my $I2_primer = "AATGATACGGCGACCACCGAGATCTACAC";
my $I2_primer_revcom = "GTGTAGATCTCGGTGGTCGCCGTATCATT";

my $adapter1 = "TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG";
my $adapter1_revcom = "CTGTCTCTTATACACATCTGACGCTGCCGACGA";
my $adapter2 = "GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG";
my $adapter2_revcom = "CTGTCTCTTATACACATCTCCGAGCCCACGAGAC";

my %I1_Name_Hash;
$I1_Name_Hash{"TAAGGCGA"}="i701";
$I1_Name_Hash{"CGTACTAG"}="i702";
$I1_Name_Hash{"AGGCAGAA"}="i703";
$I1_Name_Hash{"TCCTGAGC"}="i704";
$I1_Name_Hash{"GGACTCCT"}="i705";
$I1_Name_Hash{"TAGGCATG"}="i706";
$I1_Name_Hash{"CTCTCTAC"}="i707";
$I1_Name_Hash{"CAGAGAGG"}="i708";
$I1_Name_Hash{"GCTACGCT"}="i709";
$I1_Name_Hash{"CGAGGCTG"}="i710";
$I1_Name_Hash{"AAGAGGCA"}="i711";
$I1_Name_Hash{"GTAGAGGA"}="i712";
$I1_Name_Hash{"GCTCATGA"}="i714";
$I1_Name_Hash{"ATCTCAGG"}="i715";
$I1_Name_Hash{"ACTCGCTA"}="i716";
$I1_Name_Hash{"GGAGCTAC"}="i718";
$I1_Name_Hash{"GCGTAGTA"}="i719";
$I1_Name_Hash{"CGGAGCCT"}="i720";
$I1_Name_Hash{"TACGCTGC"}="i721";
$I1_Name_Hash{"ATGCGCAG"}="i722";
$I1_Name_Hash{"TAGCGCTC"}="i723";
$I1_Name_Hash{"ACTGAGCG"}="i724";
$I1_Name_Hash{"CCTAAGAC"}="i726";
$I1_Name_Hash{"CGATCAGT"}="i727";
$I1_Name_Hash{"TGCAGCTA"}="i728";
$I1_Name_Hash{"TCGACGTC"}="i729";


my %I2_Name_Hash;
$I2_Name_Hash{"GCGATCTA"}="i501";
$I2_Name_Hash{"ATAGAGAG"}="i502";
$I2_Name_Hash{"AGAGGATA"}="i503";
$I2_Name_Hash{"TCTACTCT"}="i504";
$I2_Name_Hash{"CTCCTTAC"}="i505";
$I2_Name_Hash{"TATGCAGT"}="i506";
$I2_Name_Hash{"TACTCCTT"}="i507";
$I2_Name_Hash{"AGGCTTAG"}="i508";
$I2_Name_Hash{"ATTAGACG"}="i510";
$I2_Name_Hash{"CGGAGAGA"}="i511";
$I2_Name_Hash{"CTAGTCGA"}="i513";
$I2_Name_Hash{"AGCTAGAA"}="i515";
$I2_Name_Hash{"ACTCTAGG"}="i516";
$I2_Name_Hash{"TCTTACGC"}="i517";
$I2_Name_Hash{"CTTAATAG"}="i518";
$I2_Name_Hash{"ATAGCCTT"}="i520";
$I2_Name_Hash{"TAAGGCTC"}="i521";
$I2_Name_Hash{"TCGCATAA"}="i522";

opendir(DIR, $inputfolder) or die "Cannot open folder: $!";

while (my $file = readdir(DIR)){
	if ($file =~ /_1.fastq/){
		my $sample = $file;
		$sample =~ s/_1.fastq.gz//;
		print "$sample\n";
		
		my $read1 =  "$inputfolder/$file";
		$read1 =~ s/.fastq.gz/.fastq/g;
		
		my $read2 =  $read1;
		$read2 =~ s/_1.fastq/_2.fastq/;
				
		my $command = "gunzip -c $read1.gz > $read1";
		system($command);
		
		$command = "gunzip -c $read2.gz > $read2";
		system($command);

		my %barcode_hash;

		open(R1, $read1) || die("Could not open $read1!");
		open(R2, $read2) || die("Could not open $read2!");

		my $line_count = 0;

		#reminded myself of code here https://stackoverflow.com/a/35814852/11205867
		
		while ((my $line1 = <R1>) and (my $line2 = <R2>)){
			chomp $line1;
			$line1 =~ s/\r//g;
			$line1 =~ s/\n//g;

			chomp $line2;
			$line2 =~ s/\r//g;
			$line2 =~ s/\n//g;
			
			$line_count++;
			
			my $interval = $line_count % 4;
			
			if($interval == 2){
				#labels are kind of confusing - I apologize about that
				#so, I was initially confused because  I thought the adapter number was different than I expected
				#however, what I call the "adapter" is what the called "read" in the Illumina PDF (so, it does make sense that you can see the reverse complement of read2 on R1), and what I am calling "primer" is what Illumina called the "adapter"
				#either way, it does make sense that I can find the reverse-complement of I1 with R1 (in small fragments), and I can find the reverse-complement of I2 with R2 (in small fragments)
				if (($line1 =~ /(\w+)$adapter2_revcom(\w{8})(\w+)/) and ($line2 =~ /(\w+)$adapter1_revcom(\w{8})(\w+)/)){
					#print "Reverse Complement Adapters Found in both R1 and R2!\n";
					#print "$line1\n";
					my ($upstreamR1,$I1,$downstreamR1)=($line1 =~ /(\w+)$adapter2_revcom(\w{8})(\w+)/);
					#if($downstreamR1 =~ /^$I1_primer_revcom\w+/){
					#	my ($downstreamR1b)=($downstreamR1 =~ /^$I1_primer_revcom(\w+)/);
					#	print "$upstreamR1   $adapter2_revcom   $I1   $I1_primer_revcom   $downstreamR1b\n";
					#}else{
					#	print "$upstreamR1   $adapter2_revcom   $I1   $downstreamR1\n";
					#}
					#print "$line2\n";
					my ($upstreamR2,$I2,$downstreamR2)=($line2 =~ /(\w+)$adapter1_revcom(\w{8})(\w+)/);
					#if($downstreamR2 =~ /^$I2_primer_revcom\w+/){
					#	my ($downstreamR2b)=($downstreamR2 =~ /^$I2_primer_revcom(\w+)/);
					#	print "$upstreamR2   $adapter1_revcom   $I2   $I2_primer_revcom   $downstreamR2b\n";
					#}else{
					#		print "$upstreamR2   $adapter1_revcom   $I2   $downstreamR2\n";
					#}
					
					my $I1_name = "-";
					if(defined($I1_Name_Hash{$I1})){
						$I1_name = $I1_Name_Hash{$I1};
					}
					my $I2_name = "-";
					if(defined($I2_Name_Hash{$I2})){
						$I2_name = $I2_Name_Hash{$I2};
					}
					
					my $dual_barcode =  "$I1\t$I1_name\t$I2\t$I2_name";
					#print "$dual_barcode\n";
					#exit;
					
					if(exists($barcode_hash{$dual_barcode})){
						$barcode_hash{$dual_barcode}=$barcode_hash{$dual_barcode}+1;
					}else{
						$barcode_hash{$dual_barcode}=1;
					}
				}#end if (($line2 =~ /$adapter1_revcom/) and ($line1 =~ /$adapter2_revcom/))

			}#end if($interval == 2)
		}#end while (<R1> and <R2>)
		close(R1);
		close(R2);

		foreach my $barcode (keys %barcode_hash){
			print BARCODE $sample."\t".$barcode."\t".$barcode_hash{$barcode}."\n";
		}

		$command = "rm $read1";
		system($command);
		
		$command = "rm $read2";
		system($command);
	}
}#end while (my $file = readdir(DIR))

closedir(DIR);

close(BARCODE);

exit;