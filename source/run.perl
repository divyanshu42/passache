####################################################################
#
# run.perl
# Kelly Itakura
#
# Creates a single run of passage retrieval. Parameters, $k, $b, 
# $avg can be passed in the call e.g. "perl run.perl --k=2, --b=0.8" to 
# train the sytem. 
#  
# Parameters: 
# $training=1 if the first run was already made.
# $k, $b , $avg BM25 parameters to be tuned.
# $numres; the number of results passages produced for each topic.
#
# Input: "topics.txt" in the format "topicID key words etc." 
# Output: "results.txt" in the format of "topicID rank\n passage"
#
####################################################################


#!/usr/local/bin/perl -w
use Getopt::Long;
#use strict;
#use diagnostics;

my $wumpus='wumpus/bin/wumpus --config=wumpus/wumpus.cfg';
my $training=0; 
my @topicIDs;
my $topic;
my $k, $b, $avg;
my $numres=150;

GetOptions ("training"=> \$training,"k:f"=>\$k, "b:f"=>\$b, "avg:f"=>\$avg, "numres:f"=>\$numres );

#When running a training set, only need to run this once.
if ($training==0){
	system("perl buildIndex.perl | $wumpus > fileTitle.txt");
	system("perl filePos2Title.perl"); #Optional

	open (TOPICID, "topics.txt") or die "Couldn't open topics.txt";
	while (<TOPICID>){
		@res=split(" ",$_);
		push(@topicIDs, $res[0]);
	}
	close TOPICID;

	system("rm -r topics");
	system("mkdir topics");
	for my $t (@topicIDs){
	system("perl getAllPos.perl --topic=$t | $wumpus > topics/$t");
	}

	system("rm everything.*");
	for $topic(@topicIDs){
		system("perl getEverything.perl --topic=$topic");
	}

	system("perl idf.perl");
}

####################################################################
# Only need to repeat the code below for training.
####################################################################

system("./getScores $k $b $avg");
system("sort -k 1,1n -k 2,2nr -k 3,3n -k 4,4n scoredTopics.txt -o scoredTopics.txt.s");
system("./getPath $numres | $wumpus > results.txt ");
system("perl format.perl --numres=$numres"); #If you are in hurry you can comment this out and can still see results.txt.
