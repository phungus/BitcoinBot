package Bot::BasicBot::Pluggable::Module::Blackjack;

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use Games::Blackjack;

our $VERSION = '0.1';


sub init {
    my $self = shift;
}

sub help {
    return "Blackjack commands: .bj, hit, stand, split, .bjstats";
}

sub told {
	my ($self, $mess) = @_;
	my $body = $mess->{body};
	return 0 unless defined $body;
    #return if !$self->bot->module->ident( $mess->{who} );
	return unless $mess->{address};

	my $player = "$mess->{who}";
	
	if ($body =~ /.bj/) {

		my $msg;
		my $shoe = Games::Blackjack::Shoe->new(nof_decks => 4);
		my $dhand = Games::Blackjack::Hand->new(shoe => $shoe);
		my $phand = Games::Blackjack::Hand->new(shoe => $shoe);

### This may not be right
#		$self->set($player => {
		my %hash = (
			shoe	=> $shoe,
			phand	=> $phand,
			dhand	=> $dhand,
			bgame	=> 1,
		);
###
		$self->{$player} = \%hash;

		my $test = $self->{$player}{"bgame"};
		_privatesay($self, $player, "New BlackJack game for $player: $test");

		# Dealer goes first
		$dhand->draw();
		$msg = "[" . $dhand->count_as_string() . "] : " . $dhand->as_string();
		_privatesay($self, $player, "Dealer has: $msg");
		# Dealer shows only one card
		$dhand->draw();
		
		# Player shows both cards
		$phand->draw();
		$phand->draw();
		$msg = "[" . $phand->count_as_string() . "] : " . $phand->as_string();
		_privatesay($self, $player, "Player has: $msg");


		# if (can split) {
		# split routine goes here
		# else
		return "Your move -- hit, stand";

	}
	elsif ($body =~ /hit/) {
		my $thing = $self->get("$player")->{"bgame"};
		return ("This: $thing");

#		my $hash = $self->get($player);
#		my $dhand = $hash{"dhand"};
#		my $phand = $hash{"phand"};
#		my $bgame = $hash{"bgame"};
my ($phand, $dhand, $bgame);

		return "No game started -- $dhand, $phand, $bgame -- .bj to start a new one!" if ($bgame == 0);
		$phand->draw();
		
		my $msg = $phand->as_string();
		my $count = $phand->count_as_string();

		if ($phand->busted()) {

			$self->set($player)->{"bgame"} = 0;
			_privatesay($self, $player, "$player draws $msg -- $count!");
			return "$player lost. Try again!";

		}
		else {

			_privatesay($self, $player, "Player has: $count : $msg");

			if ($count == 21) {
				return "Command: stand";
			}
			else {
				return "Command: hit, stand";
			}

		}

	}
	elsif ($body =~ /stand/) {
		return "Command: stand";
	}
	elsif ($body =~ /split/) {
		# split
		return "Command: split";
	}
	elsif ($body =~ /.bjstats/) {

		return "Stats for $mess->{who}";

	}
}


sub _privatesay {
	my ($self, $player, $body) = @_;
	$self->say(
		channel	=> "msg",
		who 	=> $player,
		body	=> $body
	);
}

1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Blackjack - Blackjack game for BitcoinBot

=head1 VERSION

version 0.1

=head1 IRC USAGE

Blackjack game implemented in pluggable BitcoinBot (Bot::BasicBot::Pluggable)

=over 4

=item ~newbj

Create new blackjack game

=over 4

=back

=head1 VARS

=over 4

=item None implemented

=back

=head1 AUTHOR

phungus <phungus@gmx.com>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

