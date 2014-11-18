#!/usr/bin/perl

use strict;

my @out = `netstat -ant|egrep '.80.*ESTABLISHED'|awk '{print \$4,\$5}'|sort -u`;
my %ips;

foreach my $line (@out) {
	chomp($line);
	$line =~ /(.*\..*\..*\..*)(\..*) (.*\..*\..*\..*)\..*/;
	if ( $2 == ".80" ) {
		$ips{$3} += 1;
	}
}

open(LOG, ">>/var/log/blackip.log");
foreach my $ip (sort keys %ips) {
#	print "$ip - $ips{$ip}\n";
	if ( $ips{$ip} > 9 ) {
		print "$ip - $ips{$ip}\n";
		print LOG scalar localtime;
		print LOG " from $ip; $ips{$ip} connections\n"; 
	}
}
close(LOG);
