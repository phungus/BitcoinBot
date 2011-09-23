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
	
	if ($body =~ /^.bj$/) {

		if ($self->var($player)) {
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

		$dhand->draw();
		$msgd = $dhand->count_as_string() . " - " . $dhand->as_string();
		_privatesay($self, $player, "Dealer has: $msgd");
		$dhand->draw();
		
		$phand->draw();
		$phand->draw();
		$msgp = $phand->count_as_string() . " - " . $phand->as_string();
		_privatesay($self, $player, "$player has $msgp");
#		my $games = $self->get($player)->{"games"};

		$self->unset($player);
		if ($phand->count("hard") == 21) {
			_privatesay($self, $player, "$player wins with Blackjack!");
		}
		else {
			$self->set($player => {
				bgame	=> 1,
				shoe	=> $shoe,
				phand	=> $phand,
				dhand	=> $dhand,
#				games	=> $games++,
			});

		# if (can split) {
		# split routine goes below
		# }

			return "Commands: hit, stand";
		}
	}
	elsif ($body =~ /hit/) {

		return "No game started -- .bj to start a new one" unless $self->get($player);

		my $dhand = $self->get($player)->{"dhand"};
		my $phand = $self->get($player)->{"phand"};
		my $hit = $self->get($player)->{"hit"} ||= 0;

		$phand->draw();
		
		my $msgp = $phand->as_string();
		my $cntp = $phand->count_as_string();
		my $msgd = $dhand->as_string();
		my $cntd = $dhand->count_as_string();

		if ($phand->busted()) {

			_privatesay($self, $player, "$player has $cntp - $msgp");
			$self->unset($player);
			return "$player lost. Try again!";

		}
		else {

			$self->unset($player);
			$self->set($player => {
						dhand 	=> $dhand,
						phand 	=> $phand,
						bgame 	=> 1,
						hit 	=> 1,
			});

			_privatesay($self, $player, "$player has: $cntp - $msgp");

			unless ($hit == 1) {
				if ($cntp == 21 || $cntp eq "Blackjack") {
					return "Command: stand";
				}
				else {
					return "Command: hit, stand";
				}
			}
		}

	}
	elsif ($body =~ /stand/) {

		return "No game started -- .bj to start a new one" unless $self->get($player);

		my $dhand = $self->get($player)->{"dhand"};
		my $phand = $self->get($player)->{"phand"};
		my $pmsg = $phand->as_string();
		my $pcnt = $phand->count_as_string();
		_privatesay($self, $player, "$player stands with $pcnt - $pmsg");

		my $dmsg = $dhand->as_string();
		my $dcnt = $dhand->count_as_string();
		_privatesay($self, $player, "Dealer has: $dcnt - $dmsg");

		 while(!$dhand->busted() and $dhand->count("soft") < 17) {
			$dhand->draw();
			my $msgd = $dhand->as_string();
			my $cntd = $dhand->count_as_string();
			_privatesay($self, $player, "Dealer has: $cntd - $msgd");
		}

		my $dfcnt = $dhand->count("hard");
		my $pfcnt = $phand->count("hard");
		$dcnt = $dhand->count_as_string();
		if ($pfcnt > $dfcnt) {
			_privatesay($self, $player, "$player wins with $pcnt!");
		}
		else {
			_privatesay($self, $player, "Dealer wins with $dcnt!");
		}
		$self->unset($player);
	}	
	
	elsif ($body =~ /split/) {
		# split
		return "Command: split";
	}
	elsif ($body =~ /.bjstats/) {
#		$games = $self->get($player)->{"games"};
		return "Stats for $player -- ";
# Number of games played: $games";

	}
	elsif ($body =~ /~players/) {
		my @keys = $self->store_keys;
		my $msg = join(" /-/ ", @keys);
		return "Players: $msg";
	}
#	elsif ($body =~ /~announce/) {
#		$self->tell(
#	}
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

