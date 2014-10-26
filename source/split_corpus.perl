#!/usr/local/bin/perl -w
use Getopt::Long;
#use strict;
#use diagnostics;

my $part=1;
GetOptions ("part:f"=>\$part);
my $filename="wikipedia-".$part.".xml";
my $totallinecount=0; #778632460;

#Count the total number of lines so we can split into half.
open(IN, "$filename") or die;
while(<IN>){
	$totallinecount++;
}
close IN;
my $cutoff=$totallinecount/2;

my $c=0;
open(OUT, ">temp.txt") or die;
open(IN, $filename) or die;
while(<IN>){
	$c++;
	if($part==2 && $c<$cutoff){ next;}
	if($part==1 && $c>=$cutoff){
			last;
	}
	print OUT $_;
}
close IN;
close OUT;

system("cp temp.txt $filename"); 

