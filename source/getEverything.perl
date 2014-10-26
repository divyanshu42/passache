##############################################################################################
#
# getEverything.perl
# Kelly Itakura
#
# For each file, get all pairs of keyword positions.
# Outputs to everything.txt 
#
################################################################################################


#!/usr/local/bin/perl -w
use Getopt::Long;
#use strict;
#use diagnostics;


my $topic;
GetOptions ("topic:f"=>\$topic);

my @filepos;
open (FILEPOS, "filePos.txt") or die "Couldn't open filePos.txt";
	while (<FILEPOS>){
		if($_=~/@/){
			next;
		}
		if($_=~/^$/){
			next;
		}
                	my @res=split(" ",$_);
			push(@filepos, $res[0]);

	}
close FILEPOS;
push(@filepos, -2); # means it's the end.


open(OUT2, ">getEverything.tmp") or die;

my $npos=-1;
my $cpos=-1;
my $i=-1; # index for @filePos
my $keyI=0; # index for @keyword
my $pos;
my %map;
my @pos; 

open(TOPICETTE, "topics/$topic") or die "Couldn't open topics/$topic";
while (<TOPICETTE>){
	if($_=~/^$/){
		next;
	}
	if($_=~/\@1/){
		next;
	}
	if($_=~/\@/){

		$cpos=-1;
		$npos=-1;
		$i=-1;
		$keyI++;
		#print "topic=$topic  keyword=$keyI\n";
		next;
	}
	@res=split(" ",$_);
	$pos=$res[0];

	# new xml file 
	if($pos>=$npos && $npos>=-1){ 


		# go to a new xml file.

		while($pos>=$npos && $npos>=-1){
			$i++;
			$cpos=$npos;
			$npos=$filepos[$i];
		}

	} # end if ($pos>=$npos)
		print OUT2 "$cpos $pos $keyI\n";

	} # end whie (<TOPICETTE>)
	close TOPICETTE;
	close OUT2;

system("sort -k 1,1n -k 2,2n getEverything.tmp -o getEverything.tmp.s");

my $fp=0;
my @k;
open (OUT, ">>everything.txt") or print "Couldn't open everything.txt for overwrite.";
open(IN, "getEverything.tmp.s") or die;
while(<IN>){
	my @stuff=split(" ",$_);
	if($fp==0){
		$fp=$stuff[0];
		print OUT "$fp \# $topic \# ";
	}
	if($fp!=0 && $fp!=$stuff[0]){
		print OUT "\# ";
		for(my $i=0; $i<=$#k; $i++){
			print OUT "$k[$i] ";
		}
		print OUT "\n";
		$fp=$stuff[0];
		$#k=-1;
		print OUT "$fp \# $topic \# ";
	}
	print OUT "$stuff[1] ";
	push(@k, $stuff[2]);	
}
close IN;

print OUT "\# ";
for(my $i=0; $i<=$#k; $i++){
	print OUT "$k[$i] ";
}
print OUT "\n";

system("rm getEverything.tmp getEverything.tmp.s");
close OUT;

