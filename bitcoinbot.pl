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
use Finance::Bitcoin;
use DBI;
use DBIx::AutoReconnect;

my $V = "0.1";

my $configFile = "./BitcoinBot.conf";
my $config = (!-e $configFile) ? Config::JSON->create($configFile) : Config::JSON->new($configFile);

if (!$config->get("Channels")) {
	$config->addToArray("Channels","#BitcoinBot");
	$config->addToArray("Channels","#bitcoin-bots");
}
$config->set("server","irc.freenode.net") 			unless ($config->get("server"));
$config->set("port",7000) 							unless ($config->get("port"));
$config->set("nick","TestBitcoinBot") 				unless ($config->get("nick"));
$config->set("username",$ENV{USER}) 				unless ($config->get("username"));
$config->set("ssl",1) 								unless ($config->get("ssl"));
$config->set("rpcuser","bitcoinrpcuser") 			unless ($config->get("rpcuser"));
$config->set("rpcpass","longbitcoinrpcpassword") 	unless ($config->get("rpcpass"));
$config->set("rpchost","127.0.0.1") 				unless ($config->get("rpchost"));
$config->set("rpcport",8332) 						unless ($config->get("rpcport"));
$config->set("dbuser",'') 							unless ($config->get("dbuser"));
$config->set("dbpass",'') 							unless ($config->get("dbpass"));

my $uri     = 'http://' . $config->get("rpcuser") .
                    ':' . $config->get("rpcpass") .
                    '@' . $config->get("rpchost") .
                    ':' . $config->get("rpcport") . '/';


# This could use a nice full-screen interface library. It feels so scripty.

my $botNick 	= $config->get("nick");
my $userName 	= $config->get("username");
my @channels	= @{$config->get("Channels")};
my $ircServer	= $config->get("server");
my $ircPort		= $config->get("port");

print "=============================\n";
print "= BitcoinBot - Version $V  =\n";
print "=============================\n\n";
print "Using Config: $configFile\n";
print "Nick $botNick ($userName)\n";
print "Channel(s)";
foreach (@channels) {
	print ", " . $_;
}
print "\n";
print "Connecting to $ircServer on port $ircPort\n"; 
print "-----------------------------\n\n";

### Bot Init ###

my $bot = Bot::BasicBot::Pluggable->new(
    channels	=> [@channels],
    server		=> $ircServer,
	port		=> $ircPort,
    nick    	=> $botNick,
	username	=> $userName,
	name		=> $userName,
	ssl			=> 1,
#	ignore_list	=> [qw(user1 user2)],
	rpcuser		=> $config->get("rpcuser"),
	rpcpass		=> $config->get("rpcpass"),
	rpchost		=> $config->get("rpchost"),
	rpcport		=> $config->get("rpcport"),
	wallet 		=> Finance::Bitcoin::Wallet->new($uri),
	loglevel	=> "warn",
#	store		=> "DBI",
#	dsn			=> "DBI:mysql:bbbdb",
#	table		=> "bitcoinbot",
#	user		=> $config->get("dbuser"),
#	password	=> $config->get("dbpass"),
	dbh			=> DBIx::AutoReconnect->connect("DBI:mysql:database=bbbdb;host=localhost", $config->get("dbuser"), $config->get("dbpass"),
						{
							PrintError => 0,
							ReconnectTimeout => 5,
							ReconnectFailure => sub { warn "Unable to reconnect MySQL DB" },
						},
					),
);



### Load Modules ###

# We use Auth and Loader only for administrative functions
#  and because we want to be able to quickly turn off individual games,
#  but not necessarily stop all games in progress in the event of a problem.
# May want a quick kill switch for everything.
# Have to build a separate Ident module for authentication users
# Even authenticated admins should not be able to change any game playing data
#  or player account addresses.

$bot->load("Auth");
$bot->load("Loader");

$bot->run();


