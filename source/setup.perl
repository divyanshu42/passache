#######################################################################
#
# setup.perl
# Kelly Itakura
#
# Downloads Wumpus search engine and Wikipdia corpus and setsup.
#
########################################################################

#!/usr/local/bin/perl -w
use Getopt::Long;
#use strict;
#use diagnostics;

my $wumpus='wumpus/bin/wumpus --config=wumpus/wumpus.cfg';


#setup wumpus search engine.
print "Downloading Wumpus search engine from http://www.wumpus-search.org/download/wumpus-2011-11-10.tgz...";
system("wget http://www.wumpus-search.org/download/wumpus-2011-11-10.tgz");
print "Unpacking Wumpus search engine...";
system("tar xzf  wumpus-2011-11-10.tgz");
chdir("wumpus") or die "Couldn't change into /wumpus";
print "Configuring wumpus.cfg...";
system("perl ../config_wumpus.perl");
print "Installing Wumpus search engine...";
system("make");
chdir("..") or die "Couldn't return to ..";
print "Wumpus search engine setup complete.";

#setup Wikipedia corpus.
print "Downloading English Wikipedia corpus from http://download.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2...";
system("wget http://download.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2");
print "Unpacking the Wikipedia corpus...";
system("bzip2 -d enwiki-latest-pages-articles.xml.bz2");
print "Splitting the corpus into 2 for easier indexing..";
system("cp enwiki-latest-pages-articles.xml wikipedia-1.xml");
system("cp enwiki-latest-pages-articles.xml wikipedia-2.xml");
system("perl split_corpus.perl --part=1");
system("perl split_corpus.perl --part=2"); 


print "Indexing corpus with Wumpus search engine...";
system("echo '\@addfile wikipedia*.xml' | $wumpus");
print "Installation done!";
