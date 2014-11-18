#!/usr/bin/perl -w

use strict;
use POSIX qw/strftime/;
use Net::DNS;

my $SENDMAIL = '/usr/sbin/sendmail -t -odb';
my $REGISTRATOR = 'noc-dns@relcom.net';
my $NIC_HANDLE = 'MVM3-RIPN';
my $date = strftime("%Y%m%d",localtime);
my $MAIL_TEMPLATE = "domain: __DOMAIN__\ndescr: __DOMAIN__\nadmin-c: $NIC_HANDLE\nzone-c: $NIC_HANDLE\ntech-c: $NIC_HANDLE\nnserver: ns1.portpc-design.spb.ru\nnserver: ns2.portpc-design.spb.ru\nchanged: noc\@portpc-design.spb.ru $date\nsource: RIPN";

my $domain = $ARGV[0];

sub send_message {
	my ($domain) = @_;

	(my $template = $MAIL_TEMPLATE) =~ s/__DOMAIN__/$domain/g;

	open (MAIL,"|$SENDMAIL") or die "$!";
	print MAIL "From: noc\@portpc-design.spb.ru\n";
	print MAIL "To: $REGISTRATOR\n";
	print MAIL "Subject: zone\n\n";
	print MAIL "$template";
	close MAIL;

}

if (not defined $domain or $domain eq '' or $domain !~ /\.(spb|com)\.(ru|su)/ or $domain =~ /\..*?\..*?\./ or $domain !~ /[.A-Za-z-]/) {
	print "Sorry, please enter third-level spb.ru, spb.su domains only! You may use alphanumeric symbols and dashes ('-').\n";
	exit 1;
}

send_message($domain);
