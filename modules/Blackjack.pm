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

		if ($self->var($player)) {
			_privatesay($self, $player, "Have player hash");
			if ($self->get($player)->{"bgame"} == 1) {
				return "Game already started! Command: hit, stand";
			}
			$self->unset($player);
		}

		my $msgd;
		my $msgp;
		my $shoe = Games::Blackjack::Shoe->new(nof_decks => 4);
		my $dhand = Games::Blackjack::Hand->new(shoe => $shoe);
		my $phand = Games::Blackjack::Hand->new(shoe => $shoe);

		# Dealer goes first
		$dhand->draw();
		$msgd = "[" . $dhand->count_as_string() . "] : " . $dhand->as_string();
		_privatesay($self, $player, "Dealer has: $msgd");
		# Dealer shows only one card
		$dhand->draw();
		
		# Player shows both cards
		$phand->draw();
		$phand->draw();
		$msgp = "[" . $phand->count_as_string() . "] : " . $phand->as_string();
		_privatesay($self, $player, "Player has: $msgp");

		$self->unset($player);
		$self->set($player => {
			bgame	=> 1,
			shoe	=> $shoe,
			phand	=> $phand,
			dhand	=> $dhand,
		});

		# if (can split) {
		# split routine goes here

		return "Your move -- hit, stand";

	}
	elsif ($body =~ /hit/) {

		return "No game started -- .bj to start a new one" unless $self->get($player);

		my $dhand = $self->get($player)->{"dhand"};
		my $phand = $self->get($player)->{"phand"};

		$phand->draw();
		
		my $msgp = $phand->as_string();
		my $cntp = $phand->count_as_string();
		my $msgd = $dhand->as_string();
		my $cntd = $dhand->count_as_string();

#		_privatesay($self, $player, "phandas: $msgp, phandcas: $cntp, dhandas: $msgd, dhandcas: $cntd");

		if ($phand->busted()) {

			_privatesay($self, $player, "$player draws $msgp -- $cntp!");
			$self->unset($player);
			return "$player lost. Try again!";

		}
		else {

			$self->unset($player);
			$self->set($player => {
						dhand => $dhand,
						phand => $phand,
						bgame => 1,
			});

			_privatesay($self, $player, "Player has: $cntp : $msgp");

			if ($cntp == 21) {
				return "Command: stand";
			}
			else {
				return "Command: hit, stand";
			}
		}

	}
	elsif ($body =~ /stand/) {

		return "No game started -- .bj to start a new one" unless $self->get($player);

		my $dhand = $self->get($player)->{"dhand"};
		my $phand = $self->get($player)->{"phand"};
		my $pcnt = $phand->count_as_string();
		_privatesay($self, $player, "Player stands with $pcnt");

		 while(!$dhand->busted() and $dhand->count("soft") < 17) {
			my $draw = $dhand->draw();
			my $msgd = $dhand->as_string();
			my $cntd = $dhand->count_as_string();
			_privatesay($self, $player, "Dealer draws: $draw - $msgd - $cntd");
		}
		
	}	
	
	elsif ($body =~ /split/) {
		# split
		return "Command: split";
	}
	elsif ($body =~ /.bjstats/) {

		return "Stats for $mess->{who}";

	}
	elsif ($body =~ /.reset/) {
		my @keys = $self->store_keys;
		my $msg = join(",", @keys);
		$self->unset($player);
		return "Store keys deleted: $msg";
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

