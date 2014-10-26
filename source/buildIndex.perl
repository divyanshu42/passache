###################################################
#
# buildIndex.perl
# Kelly Itakura
# 
# Outputs to filePos.txt which contains the beginning word position of new
# articles (becuase the corpus is two single files).
#
###################################################

#!/usr/local/bin/perl -w

my $wumpus='wumpus/bin/wumpus --config=wumpus/wumpus.cfg';


my $query='@gcl[count=999999999] "<title>".."</title>"'."\n";
system ( "echo '$query' | $wumpus > filePos.txt");

$query='';
open(IN, "filePos.txt") or die;
while(<IN>){
	if($_=~/\@/){ next; }
	chomp($_);
	my @stuff=split(" ",$_);
	$query.='@get '.$stuff[0].' '.$stuff[1]."\n";
}
close IN;

print $query;
