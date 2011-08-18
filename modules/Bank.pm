package Bot::BasicBot::Pluggable::Module::Bank;

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use Finance::Bitcoin;

our $VERSION = '0.1';


sub init {
    my $self = shift;

}

sub help {
    return "Bank commands: ~dep[osit] ~bal[ance] ~wit[hdraw]";
}

sub told {
	my ($self, $mess) = @_;
	my $body = $mess->{body};
	return 0 unless defined $body;
    #return if !$self->bot->module->ident( $mess->{who} );
	return unless $mess->{address};
	
	if ($body =~ /~bal/) {
		my $balance = $self->bot->{wallet}->balance;
		return "Bitcoin getbalance for $mess->{who}: $balance\n";
	}
	elsif ($body =~ /~dep/) {
		# Deposit procedure
		return "";
	}
	elsif ($body =~ /~wit/) {
		# Withdraw procedure
		return "";
	}
}


1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Bank - Implements bitcoin transaction functions

=head1 VERSION

version 0.1

=head1 IRC USAGE

WARNING: All commands require identification through the ~ident command, provided
by the Bot::BasicBot::Pluggable::Module::Ident module. Users will need to
generate a unique address to use on the bot for withdrawls. This address is set on the bot
at the time a user registers. For security reasons, we do not allow users to change the withdraw
address unless there is a 0 account balance. If they should lose access to their bitcoin address
for some reason, all funds will be lost (without operator intervention). 

=over 4

=item ~balance

Get current balance for identified user.

=item !deposit

Provides a unique bitcoin address for identified user to send funds to, for use with bot functions.

=item !withdraw <withdraw address>

Initiates the withdrawl process for sending bitcoins to an identified user using <withdraw address>
as the identifying, second level password. <withdraw address> is recorded during new user setup.

=back

=head1 VARS

=over 4

=item None implemented

=back

=head1 AUTHOR

phungus <phungus@gmx.com>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

