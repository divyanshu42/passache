################################################################################
#
# getAllPos.perl
# Kelly Itakura
#
# Reads topics.txt to look for query terms for the given topicID, then
# issues a wumpus query to look for all occurrences of the terms.
#
################################################################################

#!/usr/local/bin/perl -w
#use strict;
#use diagnostics;
use Getopt::Long;


my $wumpus='wumpus/bin/wumpus --config=wumpus/wumpus.cfg';
my $topic;
GetOptions("topic=f"=>\$topic);


open (TOPICS, "topics.txt") or die "Couldn't open topics";

# for each topics, find all occurrences of query terms for each file.
while (<TOPICS>){
	my $q='';
	my @query=split(" ", $_);

	if($query[0]!=$topic){
		next;
	}

	shift(@query); #The rest contains keywords split by spaces.
	for my $k (@query){
		$k=~s/[^a-zA-Z1-9]*//g;
		$q.= '@gcl[count=999999999][id='.$topic.'] "$'.$k.'" <("<page>".."</page>")'."\n";
	}

print $q;
}
close TOPICS;
