use warnings;
use strict;
use Bio::SeqIO;

my $input_folder = "../DADA2/FLASH";
my $output_folder = "FLASH-Swarm_OTU-all";
my $OTU_table = "FLASH_combined_unique_seqs-swarm.uclust";
my $name_map = "FLASH_combined_unique_seqs-swarm_format.map";

my $command = "mkdir $output_folder";
system($command);

opendir DH, $input_folder or die "Failed to open $input_folder: $!";
my @files= readdir(DH);

foreach my $file (@files){
	if($file =~ /.count_table2$/){
		print "$file\n";
		
		my $temp_inputfile = "$input_folder/$file";
		my $temp_outputfile = "$output_folder/$file";
		
		### collect read names ###
		print "### Step 1) Collecting read times to reduce hash size... ###\n";
		my %temp_OTU_mapping_hash_rev;

		my $line_count=0;
		open(INPUTFILE, $temp_inputfile) || die("Could not open $temp_inputfile!");
		while (<INPUTFILE>){
			$line_count++;
			my $line = $_;
			chomp $line;
			if($line_count > 1){
				my @line_info = split("\t",$line);
				my $name = $line_info[1];

				$temp_OTU_mapping_hash_rev{$name}=""
			}#end if($line_count > 1)
		}#end while (<INPUTFILE>)
					
		close(INPUTFILE);
		
		### unique sequence mapping (original to unique) ###
		print "### Step 2) Map separate unique names to combined unique names (per sample)... ###\n";
		my %temp_unique_mapping_hash;

		$line_count = 0;

		open(INPUTFILE, $name_map) || die("Could not open $name_map!");
		while (<INPUTFILE>){
			my $line = $_;
			chomp $line;
				
			$line_count++;
				
			if ($line_count > 1){
				my @line_info = split("\t",$line);
				my $amp_seq = $line_info[0];
				my $unique_name = $line_info[1];
				my $uclust_name = $line_info[2];
					
				if(exists($temp_OTU_mapping_hash_rev{$unique_name})){
					$temp_unique_mapping_hash{$uclust_name}=$unique_name;
				}elsif($unique_name =~ /_/){
					my @uniq_seqs = split("_",$unique_name);
					foreach my $uniq_seq (@uniq_seqs){
						if(exists($temp_OTU_mapping_hash_rev{$uniq_seq})){
							$temp_unique_mapping_hash{$uclust_name}=$uniq_seq;
						}#end if(exists($temp_OTU_mapping_hash_rev{$unique_name}))
					}#end foreach $uniq_seq (@uniq_seqs)
				}#end elsif($unique_name =~ /_/)
			}#end if ($line_count > 1)

		}#end while (<INPUTFILE>)
						
		close(INPUTFILE);
		
		### Collect representative OTU sequence names (per sample) ###
		print "### Step 3) Map OTUs to sequences and Define rep seqs to collect (per sample)... ###\n";
		my %OTU_rep_seq_hash;
		my %temp_OTU_mapping_hash;

		open(INPUTFILE, $OTU_table) || die("Could not open $OTU_table!");
		while (<INPUTFILE>){
			my $line = $_;
			chomp $line;
			my @line_info = split("\t",$line);
			my $seq_cat = $line_info[0];
			my $OTU_num = $line_info[1];
			my $seqName = $line_info[8];
			my $repSeq = $line_info[9];
			
			if(exists($temp_unique_mapping_hash{$seqName})){
				#use for representative sequence
				if($seq_cat eq "S"){
					$OTU_rep_seq_hash{$seqName}="OTU$OTU_num";
				}elsif ($seq_cat eq "H"){
					$OTU_rep_seq_hash{$repSeq}="OTU$OTU_num";
				}
				
				#use for original mapping
				my $original_read_name = $temp_unique_mapping_hash{$seqName};
				$temp_OTU_mapping_hash{$original_read_name}="OTU$OTU_num";
			}#end if(exists($temp_unique_mapping_hash{$multisample_seq}))				
		}#end while (<INPUTFILE>)
					
		close(INPUTFILE);
		
		undef %temp_unique_mapping_hash;
		
		### Collect representative sequences for selected OTUs ###
		print "### Step 4) Collect representative OTU sequence names (per sample)... ###\n";
		my %temp_OTU_seq_hash;
		
		$line_count = 0;

		open(INPUTFILE, $name_map) || die("Could not open $name_map!");
		while (<INPUTFILE>){
			my $line = $_;
			chomp $line;
				
			$line_count++;
				
			if ($line_count > 1){
				my @line_info = split("\t",$line);
				my $amp_seq = $line_info[0];
				my $unique_name = $line_info[1];
				my $uclust_name = $line_info[2];
					
				if(exists($OTU_rep_seq_hash{$uclust_name})){
					my $temp_OTU=$OTU_rep_seq_hash{$uclust_name};
					$temp_OTU_seq_hash{$temp_OTU}=$amp_seq;

				}#end if(exists($OTU_rep_seq_hash{$uclust_name}))
			}#end if ($line_count > 1)

		}#end while (<INPUTFILE>)
						
		close(INPUTFILE);	

		undef %OTU_rep_seq_hash;
		
		### re-map count hash ###
		print "### Step 5) Go back to condense counts by OTU (per sample)... ###\n";
		my $skip_count = 0;
		my %temp_OTU_hash;
	
		$line_count=0;
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

				if(defined($temp_OTU_mapping_hash{$name})){
					my $otu = $temp_OTU_mapping_hash{$name};
					
					if(defined($temp_OTU_hash{$otu})){
						$temp_OTU_hash{$otu} =  $temp_OTU_hash{$otu} + $count; 
					}else{
						$temp_OTU_hash{$otu} =  $count;
					}
				}else{
					$skip_count++;
					if (($count > 100)&($length >= 200)&($length <= 300)){
						print "$line\n";					
						print "Problem finding OTU for target length seq with $count reads: $name\n";
						exit;
					}#end if ($count > 10)
				}#end else

			}#end if($line_count > 1)
		}#end while (<INPUTFILE>)
					
		close(INPUTFILE);
		
		print "Skipped sequences for OTU generation: $skip_count\n";
	
		### output file condensed by OTU ###
		print "### Step 6) Finally, print out OTU-level counts for this sample... ###\n";
		open(OUTPUTFILE, "> $temp_outputfile") || die("Could not open $temp_outputfile!");

		print OUTPUTFILE "Seq\tName\tCount\tLength\n";

		foreach my $otu (keys %temp_OTU_hash){
			my $count = $temp_OTU_hash{$otu};
			
			my $otu_seq="";
			if(defined($temp_OTU_seq_hash{$otu})){
				$otu_seq = $temp_OTU_seq_hash{$otu};
			}else{
				print "Problem Mapping OTU Sequence for: $otu\n";
				exit;
			}
			
			if ($otu_seq eq ""){
				print "$otu is defined but empty?\n";
				exit;
			}

			my $otu_length = length($otu_seq);
			print OUTPUTFILE "$otu_seq\t$otu\t$count\t$otu_length\n";
		}

		close(OUTPUTFILE);
	}#end if($file =~ /.count_table2$/)
}#end foreach my $file (@files)
closedir DH;

exit;
