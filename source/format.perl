#################################################
#
# format.perl
# Kelly Itakura
#
# Format the results of queries in results.txt
# The formatted output overwrites results.txt
#
#####################################################

#!/usr/local/bin/perl -w
use Getopt::Long;
#use strict;
#use diagnostics;

my $numres=150;

GetOptions ("numres:f"=>\$numres);

my $c=0, $topic=0;

open(OUT,">temp.txt") or die;
open(IN, "results.txt") or die;
<IN>; #ignores the first line.
while(<IN>){
	if($_=~/0.50000 62 64/){ #next topic, so get the topic ID.
		chomp($_);
		$_=~s/ 0.50000 62 64//;
		$topic=$_;
		$c=0;
		next;
	}
	if($_=~/\@/){
		$c++;
		if($c<=$numres){
			print OUT "************Topic $topic, Rank $c***************\n";
		}
		next;
	}
	print OUT $_;	

}
close IN;
close OUT;

system("cp temp.txt results.txt");
