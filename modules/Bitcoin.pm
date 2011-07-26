package Bot::BasicBot::Pluggable::Module::Bitcoin;
use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;

our $VERSION = '0.1';

sub init {
    my $self = shift;
#    $self->config( { config_item => 1 } );
}

sub help {
    return "Module implementing Bitcoin user functions, requires /msg.";
}

sub told {

	my ($self, $mess) = @_;
	my $body = $mess->{body};
	return 0 unless defined $body;
    return if !$self->ident( $mess->{who} );
	return unless $mess->{address};

}

1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Bitcoin - Implements bitcoin currency transaction functions

=head1 VERSION

version 0.1

=head1 IRC USAGE

WARNING: All commands require identification through the !ident command, provided
by the Bot::BasicBot::Pluggable::Module::Ident module. Users will need to
generate a unique address to use on the bot for withdrawls. For security reasons,
we do not allow users to change the withdraw address. If they should lose access
to their bitcoin address for some reason, all funds will be lost (without operator
intervention). 

=over 4

=item !getbalance

Get current balance for identified user.

=item !deposit

Provides a unique bitcoin address for identified user to send funds to, for use with bot functions.

=item !withdraw <bitcoin address>

Initiates the withdrawl process for sending bitcoins to an identified user using <bitcoin address>
as an identifying password.

=back

=head1 VARS

=over 4

=item None implemented

=back

=head1 AUTHOR

phungus <phungus@gmx.com>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

