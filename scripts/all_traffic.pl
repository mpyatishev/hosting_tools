#!/usr/bin/perl -w

use Data::Dumper;
use DBI;

my $dbh = DBI->connect("dbi:mysql:hosting","hosting","si7Pooy") or die "$!";

my $IFACE='rl0';

system("/usr/local/sbin/ipacctctl ${IFACE}_ip_acct:${IFACE} checkpoint");
my @str = `/usr/local/sbin/ipacctctl ${IFACE}_ip_acct:${IFACE} show`;
system("/usr/local/sbin/ipacctctl ${IFACE}_ip_acct:${IFACE} clear");

my (%dst,%src) = ();

foreach my $str (@str) {
	chomp $str;
	my ($src, $p_src, $dst, $p_dst, $proto, $packets, $bytes) = split(/\s+/,$str);

	if ($str =~ /accou/i) {
		print $str;
		next;
	}

	if ($dst ne '81.176.64.110' and $dst ne '195.161.118.232') {
		if ($src ne '81.176.64.110' and $src ne '195.161.118.232') {
#			print "$str\n";
		} else {
			$src{$p_src} += $bytes;
		}
	} else {
		$dst{$p_dst} += $bytes;
	}
}

foreach my $p_dst (keys %dst) {
	my $sth2 = $dbh->prepare("SELECT inb,outb FROM all_traffic WHERE port=? and mydate=CURDATE()");
	$sth2->execute($p_dst);

	my $bytes = undef;
	while (my $r = $sth2->fetch) {
		$bytes = $$r[0];
		if (not defined $bytes and defined $$r[1]) {
			$bytes = 0;
		}
	}

	if (defined $bytes) {
		my $sth = $dbh->prepare("UPDATE all_traffic SET inb=? WHERE port=? AND mydate=CURDATE()") or die "$!";
		$sth->execute($bytes+$dst{$p_dst},$p_dst) or die "$!";
	} else {
		my $sth = $dbh->prepare("INSERT INTO all_traffic SET inb=?, port=?, mydate=CURDATE()") or die "$!";
		$sth->execute($dst{$p_dst},$p_dst) or die "$!";
	}
}

foreach my $p_src (keys %src) {
	my $sth2 = $dbh->prepare("SELECT outb,inb FROM all_traffic WHERE port=? and mydate=CURDATE()");
	$sth2->execute($p_src);

	my $bytes = undef;
	while (my $r = $sth2->fetch) {
		$bytes = $$r[0];
		if (not defined $bytes and defined $$r[1]) {
			$bytes = 0;
		}
	}

	if (defined $bytes) {
		my $sth = $dbh->prepare("UPDATE all_traffic SET outb=? WHERE port=? AND mydate=CURDATE()") or die "$!";
		$sth->execute($bytes+$src{$p_src},$p_src) or die "$!";
	} else {
		my $sth = $dbh->prepare("INSERT INTO all_traffic SET outb=?, port=?, mydate=CURDATE()") or die "$!";
		$sth->execute($src{$p_src},$p_src) or die "$!";
	}
}
