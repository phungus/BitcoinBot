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

my $ConfigFile = "./BitcoinBot.conf";
my $config = (!-e $ConfigFile) ? Config::JSON->create($ConfigFile) : Config::JSON->new($ConfigFile);

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

my $BotNick 	= $config->get("nick");
my $UserName 	= $config->get("username");
my @Channels	= @{$config->get("Channels")};
my $IrcServer	= $config->get("server");
my $IrcPort		= $config->get("port");

print "=============================\n";
print "= BitcoinBot - Version $V  =\n";
print "=============================\n\n";
print "Using Config: $ConfigFile\n";
print "Nick $BotNick ($UserName)\n";
print "Channel(s): ";
print foreach (@Channels);
print "\n";
print "Connecting to $IrcServer on port $IrcPort\n"; 


### Bitcoin Init ###

my $rpcuser = $self->get("rpcuser");
my $rpcpass = $self->get("rpcpass");
my $rpchost = $self->get("rpchost");
my $rpcport = $self->get("rpcport");

my $uri     = 'http://$rpcuser:$rpcpass@$rpchost:$rpcport/';
my $wallet  = Finance::Bitcoin::Wallet->new($uri);


### Bot Init ###

my $bot = Bot::BasicBot::Pluggable->new(
    channels	=> @Channels,
    server		=> $IrcServer,
	port		=> $IrcPort,
    nick    	=> $BotNick,
	username	=> $UserName,
	name		=> $UserName,
	ssl			=> 1,
#	ignore_list	=> [qw(user1 user2)],
);

$bot->loglevel("debug");

### Load Modules ###


$bot->load("Auth");
$bot->load("Loader");

$bot->run();

