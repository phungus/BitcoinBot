#!/usr/bin/perl
#
# BitcoinBot v.1
# Uses Bot::BasicBot::Pluggable with POE on the backend
# Goal is to have a stable, secure, bitcoin-enabled IRC bot
#
# phungus (07/2011) - phungus@gmx.com
#

use warnings;
use strict;
use Bot::BasicBot::Pluggable;
use Config::JSON;


my $V = "0.1";



### Config

my $ConfigFile = "./BitcoinBot.conf";
my $config;

if (!-e $ConfigFile) {
	$config = Config::JSON->create($ConfigFile);	
	$config->addToArray("Channels","##BitcoinBot");
	$config->set("server","irc.freenode.net");
	$config->set("port",7000);
	$config->set("nick","TestBitcoinBot");
	$config->set("username",$ENV{USER});
	$config->set("ssl",1);
}

$config 	= Config::JSON->new($ConfigFile);
my $BotNick 	= $config->get("nick");
my $UserName 	= $config->get("username");
my $Channels	= $config->get("Channels");
my $IrcServer	= $config->get("server");
my $IrcPort	= $config->get("port");

print "Using Config: $ConfigFile, Nick $BotNick ($UserName)\n";
print "Channels: ";
foreach (@$Channels) {
	print $_ . " ";
}
print "\n";
print "Connecting to $IrcServer on port $IrcPort\n"; 


### Bot Init ###

my $bot = Bot::BasicBot::Pluggable->new(
    channels	=> ["##BitcoinBot"],
    server		=> "chat.freenode.net",
	port		=> 7000,
    nick    	=> "BitcoinBot",
	username	=> "BitcoinBot",
	name		=> "BitcoinBot",
	ssl			=> 1,
#	ignore_list	=> [qw(user1 user2)],
);

#$bot->log;
$bot->loglevel("debug");

### Load Modules ###

$bot->load("Seen");

#my $google = $bot->load("Google");
#$google->set("google_key", "xxxxxxxxxxxxxxx");

#$bot->load("Infobot");
$bot->load("Title");

$bot->run();

