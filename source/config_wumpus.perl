##################################################################
# 
# config_wumpus.perl
# Kelly Itakura
#
# Overwrite the default wumpus setting. The old wumpus.cfg 
# will be renamed to old_wumpus.cfg, the new file will be 
# named wumpus.cfg.
#
################################################################

open(OUT, ">temp.cfg") or die;
open(IN, "wumpus.cfg") or die;
while(<IN>){
	if($_=~/MAX_FILE_SIZE =/ ){
		$_=~s/20000/25000/;
	}
	print OUT $_;
}
close IN;
close OUT;

system("mv wumpus.cfg old_wumpus.cfg");
system("mv temp.cfg wumpus.cfg");
