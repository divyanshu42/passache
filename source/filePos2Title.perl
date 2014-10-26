################################################################
#
# filePos2Title.perl
# Kelly Itakura
# 
# Merges filePos.txt and fileTitle.txt into one filePosTitle.txt
#
#################################################################

my @pos;
open(IN, "filePos.txt") or die;
while(<IN>){
	if($_=~/\@/){ next; }
	chomp($_);
	my @stuff=split(" ",$_);
	push(@pos, $stuff[0]);
}
close IN;

open(OUT, ">filePosTitle.txt") or die;
open(IN, "fileTitle.txt") or die;
while(<IN>){
	if($_!~/<title>/){ next; }
	$_=~s/<title>//;
	$_=~s/<\/title>//;
	chomp($_);
	print OUT shift(@pos)." ".$_."\n";
}
close IN;
close OUT;
