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

my $configFile = "./BitcoinBot.conf";
my $config = (!-e $configFile) ? Config::JSON->create($configFile) : Config::JSON->new($configFile);

$config->addToArray("Channels","#BitcoinBot") 		unless ($config->get("Channels"));
$config->set("server","irc.freenode.net") 			unless ($config->get("server"));
$config->set("port",7000) 							unless ($config->get("port"));
$config->set("nick","TestBitcoinBot") 				unless ($config->get("nick"));
$config->set("username",$ENV{USER}) 				unless ($config->get("username"));
$config->set("ssl",1) 								unless ($config->get("ssl"));
$config->set("rpcuser","bitcoinrpcuser") 			unless ($config->get("rpcuser"));
$config->set("rpcpass","longbitcoinrpcpassword") 	unless ($config->get("rpcpass"));
$config->set("rpchost","127.0.0.1") 				unless ($config->get("rpchost"));
$config->set("rpcport",8332) 						unless ($config->get("rpcport"));


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
print "Channel(s): ";
print foreach (@channels);
print "\n";
print "Connecting to $ircServer on port $ircPort\n"; 


### Bitcoin Init ###

my $rpcuser = $self->get("rpcuser");
my $rpcpass = $self->get("rpcpass");
my $rpchost = $self->get("rpchost");
my $rpcport = $self->get("rpcport");

my $uri     = 'http://$rpcuser:$rpcpass@$rpchost:$rpcport/';
my $wallet  = Finance::Bitcoin::Wallet->new($uri);


### Bot Init ###

my $bot = Bot::BasicBot::Pluggable->new(
    channels	=> @channels,
    server		=> $ircServer,
	port		=> $ircPort,
    nick    	=> $botNick,
	username	=> $userName,
	name		=> $userName,
	ssl			=> 1,
#	ignore_list	=> [qw(user1 user2)],
);

$bot->loglevel("debug");

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


