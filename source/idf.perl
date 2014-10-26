###########################################################################
#
# idf.perl
# Kelly Itakura
#
# Creates idf.txt that contains idf values of all terms in topics.txt
# In the format of "<topicID> <?thTerm> <idf>"
#
############################################################################

my $wumpus='wumpus/bin/wumpus --config=wumpus/wumpus.cfg';

my $totaldocs=6638792; #total number of documents in the Wikipdia corpus.
my $query='';
my @topicID;
open(IN, "topics.txt") or die;
while(<IN>){
	chomp($_);	
	my @stuff=split(" ",$_);
	push(@topicID,$stuff[0]);
	shift(@stuff);
	$query.='@count ';
	#my %dup;
	for(my $i=0; $i<=$#stuff; $i++){
		#if($dup{$stuff[$i]}==1){
		#	next;
		#}
		#$dup{$stuff[$i]}=1;
		$query.='"'.$stuff[$i].'" <("<page>".."</page>"),';
	}
	$query=~s/,$//;
	$query.="\n";
}
close IN;

system ( "echo '$query' | $wumpus > temp.txt");

open(OUT, ">idf.txt") or die;
open(IN, "temp.txt") or die;
while(<IN>){
	if($_=~/\@/) { next;}
	chomp($_);
	my @stuff=split(" ",$_);
	my $topic=shift(@topicID);
	
	for(my $i=0; $i<=$#stuff; $i++){
		print OUT "$topic ".($i+1)." ".(log($totaldocs/$stuff[$i]))."\n";
	}	

}
close IN;
close OUT;
