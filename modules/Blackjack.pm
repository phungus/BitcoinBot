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
		my $bshoe = Games::Blackjack::Shoe->new(nof_decks => 4);
		my $dhand = Games::Blackjack::Hand->new(shoe => $bshoe);
		my $phand = Games::Blackjack::Hand->new(shoe => $bshoe);


		$self->say(
			channel => "msg",
			who => $player,
			body => "New BlackJack game for $player"
		);

		$dhand->draw();
#		$self->get($player)->{dhand}->draw();
		$msg = "[" . $dhand->count_as_string . "] : " . $dhand->as_string();
		$self->say(
			channel => "msg",
			who => $player,
			body => "Dealer has: $msg"
		);

		# Dealer shows only one card
		$dhand->draw();
		
		# Player shows both cards
		$phand->draw();
		$phand->draw();

		$msg = "[" . $phand->count_as_string . "] : " . $phand->as_string();
        $self->say(
            channel => "msg",
			who => $player,
			body => "Player has: $msg"
        );

		$self->set($player => {
			bshoe => $bshoe,
			phand => $phand,
			dhand => $dhand,
			bgame => 1
		});

		# if (can split) {
		# split routine
		# else
		return "Your move -- hit, stand";

	}
	elsif ($body =~ /.bjstats/) {

		return "Stats for $mess->{who}";

	}
	elsif ($body =~ /hit/) {

		my $pstore = \$self->get($player);
		my $dhand = $$pstore->{"dhand"};
		my $phand = $$pstore->{"phand"};
		my $bgame = $$pstore->{"bgame"};

		return "No game started -- .bj to start a new one!" if ($bgame == 0);

		my $msg = $phand->count_as_string();

		if ($msg > 21) {
			$self->say(
        	    channel => "msg",
				who => $player,
				body => "$player busts with: $msg"
        	);	
			return "$player lost. Try again!";
		}
		else {
			$self->say(
	            channel => "msg",
				who => $player,
				body => "$player now has: $msg"
	        );
			if ($msg == 21) {
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

