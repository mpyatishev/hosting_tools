#!/usr/bin/perl -w

use strict;

use POSIX qw(strftime);
use Data::Dumper;

$|=1;

my $homedir = '/www';
my @LOGS = ('access','error');
my $TODAY = strftime ("%Y_%m_%d",localtime(time-60*60*23));
my $ZIP = '/usr/local/bin/zip -j';
my $MIN_USER_ID = 2000;

opendir(HOME,"$homedir") || die("can't open home dir \"$homedir\":$!");
chdir($homedir);
my @homes = grep { not /^\./ and not -l $_ and -d $_ } readdir(HOME);
closedir(HOME);

# Add 3rd domain sites
my @homes_deep;
foreach my $home (@homes) {
	chdir($homedir);
	opendir(HOME,"$homedir/$home") || die("can't open home dir \"$homedir/$home\":$!");
	chdir("$homedir/$home");
	my @homes2 = grep { not /^\./ and not -l $_ and -d $_ } readdir(HOME);
	closedir(HOME);

	foreach my $home2 (@homes2) {
		if (-d "$home2/log") {
			push(@homes_deep, "$home/$home2");
		}
	}
}
@homes = (@homes, @homes_deep);
#print Dumper \@homes; exit;
chdir("$homedir");

foreach my $home (@homes) {

	my @filestat = stat($home);
	my ($name,$passwd,$uid,$gid,$quota,$comment,$gcos,$dir,$shell,$expire) = getpwuid($filestat[4]);
	next if not defined $dir;
	$dir = $homedir . '/' . $home;
#	print "$home - $dir\n"; next;

	next if not -d "$dir/log";

	foreach my $log (@LOGS) {
		next if not -f "$dir/log/$log" or -f "$dir/log/${log}_$TODAY.zip";
		$> = $uid;
		print "$home:\n";
		system("$ZIP \"$dir/log/${log}_$TODAY.zip\" \"$dir/log/$log\"");
		$> = 0;
		open(LOG,">$dir/log/$log");
		close LOG;
	}

}
