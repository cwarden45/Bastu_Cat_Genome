use warnings;
use strict;
use diagnostics;
use Bio::SeqIO;

my $pos = 474;		
#my $inFa="FGF5_cDNA.fa";#I am having difficulties verifing the position with either of these sequences, defined from supplemental materials of Kehler et al. 2007
#my $inFa="FGF5_CDSplus3.fa";#test translation and comparison to main figure, showing loss of stop codon for M3

#my $inFa="FGF5_UCSC_RefSeq.fa";

#my $inFa="FGF5_CDS.fa";#Supplemental Figure A1-D (BAD - at least for bold CDS)
#my $pepFa = "FGF5_prot.fa";

my $inFa="FGF5_CDS2.fa";#Supplemental FigureA1-A to A1-C (GOOD!)
my $pepFa = "FGF5_prot2.fa";

my $BLAT_query = "BLAT_474T_del.fa";
				
my $seqio_object = Bio::SeqIO->new(-file => $inFa); 
my $seq_object = $seqio_object->next_seq;
my $seq = $seq_object->seq;
print "CDS Length: ",length($seq)," nt\n";

print "Check(T): ",substr($seq,$pos,1),"\n";
print "With Flank:: ",substr($seq,$pos-2,5),"\n";

my $prot_obj = $seq_object->translate(); 
my $prot_seq = $prot_obj->seq;

open(PEP, ">$pepFa") || die("Could not open $pepFa!");
print PEP ">FGF5_pep\n$prot_seq\n";
close(PEP);

#going back to picture T deletion should change F to L (near beginning of 3rd exon)

#REMEMBER: sequence is 1-indexed and Perl is 0-indexed! (have to substract 1 from figure numbers)

#end of 1st line
my $prot_num = 47;
print "RSS pep Test: ",substr($prot_seq,$prot_num,3),"\n";

#recover SAK (upstream)
$prot_num = 154;
print "SAK pep Test: ",substr($prot_seq,$prot_num,3),"\n";

#recover altered codon (pep - 1)
$prot_num = 157;
print "FTD pep Test: ",substr($prot_seq,$prot_num,3),"\n";

#I've already subtracted 1 from the index: prot*3-2 becomes (prot_index + 1)*3-2 = prot_index*3 +1
#you then have to subtract 1 to get Perl index: prot_index *3 + 1 --> prot_index * 3
my $nuc_num = $prot_num *3;
print "Test Codon (",$nuc_num+1,"): ",substr($seq,$nuc_num,7),"\n";

#mutation causes F --> L mutation

#F(Phe) codons: TTT and TTC
#L(Leu) codons: TTA, TTG, and 4 others

#If T is being deleted, I am expecting TTT --> TTA (3rd nucleotide in codon)

#next protein is T(Thr), which is ACN (so, ACC is valid)

#TTACCG would then code for LP, which matches Figure 1A

#codon starts with 472 --> 3rd nucleotide in codon means 472 + 2 = 474!

print "Short Test: ",substr($seq,474-1,4),"\n";
my $test = substr($seq,474-1,25);
print "Long Test: $test\n";

open(BLAT, ">$BLAT_query") || die("Could not open $BLAT_query!");
print BLAT ">T474_start\n$test\n";
close(BLAT);

#reverse complement -->

#it will be better if I can have this more automated, but at least I think I know the right position for Bastu's variant
exit;