##################################################################
#
# master.perl
# Kelly Itakura
#
# Downloads, indexes corpus and then performs a single run of passage retrieval.
#
# PreReq: You may need to install Getopt::Long module from CPAN.
#
# Input: The topic file, "topics.txt" have queries in the format of 
# topicID "<query terms>".
#
# Output: The result file, "results.txt" have results in the format of 
# topicID "<passage results>". Only the top 10 results are returned but
# can be modified through parameter 'topx' passed onto run.perl.
#
# You may tune the BM25 parameters 'k' and 'b' passed to run.perl to train.
#
###################################################################

#!/usr/local/bin/perl -w
use Getopt::Long;
#use strict;
#use diagnostics;

#Downloads and setup/index Wikipedia corpus with Wumpus search engine.
system("perl setup.perl");

#Make one run of arbitrary passage retrieval with a given parameter.
system("perl run.perl");
