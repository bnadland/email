#!/usr/bin/perl
use strict;
use warnings;
use 5.012;
use Courriel;
use Data::Dumper;
use Mail::IMAPClient;

my $imap = Mail::IMAPClient->new(
  Server   => 'imap.gmail.com',
  User     => 'username',
  Password => 'password',
  Ssl      => 1,
  Uid      => 1,
);

#my $folders = $imap->folders or die "List folders error: ", $imap->LastError, "\n";
my $folder = 'INBOX';
$imap->select($folder) or die "Select '$folder' error: ", $imap->LastError, "\n";

my @ids = $imap->messages;
foreach my $id (@ids) {
	my $email = Courriel->parse(text => $imap->message_string($id));

	foreach my $part ($email->parts) {
		my $header = $part->headers();
		my $subject = $header->get_values('Subject');
		if($subject) {
			say "Subject: ".$subject;
		}
		#say $part->content();
	}
}

$imap->logout or die "Logout error: ", $imap->LastError, "\n";
