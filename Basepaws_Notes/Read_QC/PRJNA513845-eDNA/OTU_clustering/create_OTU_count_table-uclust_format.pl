use warnings;
use strict;
use Bio::SeqIO;

my $input_folder = "../DADA2/FLASH";
my $output_folder = "FLASH-VSEARCH_OTU-min_2reads";
my $OTU_table = "FLASH_combined_VSEARCH_cluster-min_2_reads.txt";
my $OTU_FA = "FLASH_combined_VSEARCH_cluster-min_2_reads.fa";

my $command = "mkdir $output_folder";
system($command);

#create OTU seq hash
print "### Step 1) Create sequence hash from OTU FASTA file... ###\n";
my %OTU_seq_hash_FULL;

my $inseq = Bio::SeqIO->new(-file   => "$OTU_FA",
                            -format => "FASTA" );

while (my $seq = $inseq->next_seq) {
   my $temp_name =  $seq->id;
   my $temp_seq =   $seq->seq;
   $OTU_seq_hash_FULL{$temp_name}=$temp_seq;
}

#create OTU hash
print "### Step 2) Create OTU matching hash... ###\n";
my %OTU_mapping_hash;
my %OTU_seq_hash;

open(INPUTFILE, $OTU_table) || die("Could not open $OTU_table!");
while (<INPUTFILE>){
	my $line = $_;
	chomp $line;
	my @line_info = split("\t",$line);
	my $seq_cat = $line_info[0];
	my $OTU_num = $line_info[1];
	my $seqName = $line_info[8];
	
	if($seqName =~ /_/){
		my @name_arr = split("\t",$seqName);
		
		foreach my $multisample_seq (@name_arr){
			if($seq_cat eq "S"){
				if(not(defined($OTU_seq_hash{"OTU$OTU_num"}))){
					if(defined($OTU_seq_hash_FULL{$seqName})){
						$OTU_seq_hash{"OTU$OTU_num"}=$OTU_seq_hash_FULL{$seqName}
					}else{
						print "$line\n";
						print "Problem finding centroid sequence: $seqName\n";
						exit;
					}
				}#end if(not(defined($OTU_seq_hash{"OTU$OTU_num"})))
				
				$OTU_mapping_hash{$multisample_seq}="OTU$OTU_num";
			}elsif ($seq_cat eq "H"){
				$OTU_mapping_hash{$multisample_seq}="OTU$OTU_num";
			}
		}#end foreach $identical_seq (@name_arr)
	}else{
		if($seq_cat eq "S"){
			if(defined($OTU_seq_hash_FULL{$seqName})){
				$OTU_seq_hash{"OTU$OTU_num"}=$OTU_seq_hash_FULL{$seqName}
			}else{
				print "$line\n";
				print "Problem finding centroid sequence: $seqName\n";
				exit;
			}
			$OTU_mapping_hash{$seqName}="OTU$OTU_num";
		}elsif ($seq_cat eq "H"){
			$OTU_mapping_hash{$seqName}="OTU$OTU_num";
		}
	}#end else

}#end while (<INPUTFILE>)
			
close(INPUTFILE);

undef %OTU_seq_hash_FULL;

#combine counts among members of a cluster
print "### Step 3) Convert individual files... ###\n";

opendir DH, $input_folder or die "Failed to open $input_folder: $!";
my @files= readdir(DH);

foreach my $file (@files){
	if($file =~ /.count_table2$/){
		print "$file\n";
		
		my $temp_inputfile = "$input_folder/$file";
		my $temp_outputfile = "$output_folder/$file";
		
		#create count hash
		my %temp_OTU_hash;
		my $skip_count = 0;
	
		my $line_count=0;
		open(INPUTFILE, $temp_inputfile) || die("Could not open $temp_inputfile!");
		while (<INPUTFILE>){
			$line_count++;
			my $line = $_;
			chomp $line;
			if($line_count > 1){
				my @line_info = split("\t",$line);
				my $name = $line_info[1];
				my $count = $line_info[2];
				my $length = $line_info[3];

				if(defined($OTU_mapping_hash{$name})){
					my $otu = $OTU_mapping_hash{$name};
					
					if(defined($temp_OTU_hash{$otu})){
						$temp_OTU_hash{$otu} =  $temp_OTU_hash{$otu} + $count; 
					}else{
						$temp_OTU_hash{$otu} =  $count;
					}
				}else{
					$skip_count++;
					if (($count > 10)&($length >= 200)&($length <= 300)){
						#print "$line\n";					
						print "Problem finding OTU for target length seq with $count reads: $name\n";
						#exit;
					}#end if ($count > 10)
				}#end else

			}#end if($line_count > 1)
		}#end while (<INPUTFILE>)
					
		close(INPUTFILE);
		
		print "Skipped sequences for OTU generation: $skip_count\n";
	
		#output file condensed by OTU
		open(OUTPUTFILE, "> $temp_outputfile") || die("Could not open $temp_outputfile!");

		print OUTPUTFILE "Seq\tName\tCount\tLength\n";

		foreach my $otu (keys %temp_OTU_hash){
			my $count = $temp_OTU_hash{$otu};
			my $otu_seq = $OTU_seq_hash{$otu};
			my $otu_length = length($otu_seq);
			print OUTPUTFILE "$otu_seq\t$otu\t$count\t$otu_length\n";
		}

		close(OUTPUTFILE);
	}#end if($file =~ /.count_table2$/)
}#end foreach my $file (@files)
closedir DH;

exit;
