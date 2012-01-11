package Bot::BasicBot::Pluggable::Module::Test;

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use Data::Dumper;


our $VERSION = '0.1';


sub init {
    my $self = shift;
	
}

sub help {
    return "Test Commands";
}



sub told {
	my ($self, $mess) = @_;
	my $body = $mess->{body};
	return 0 unless defined $body;
    #return if !$self->bot->module->ident( $mess->{who} );
	#return unless $mess->{address};
	return unless $self->authed($mess->{who});

	if ($body =~ /^.testCmd$/) {
		return ("Received testCmd");
	}
}


1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Test

=head1 VERSION

version 0.1

=head1 IRC USAGE

=over 4

=item .testCmd

=back

=head1 VARS

=over 4

=item None implemented

=back

=head1 AUTHOR

phungus <phungus@gmx.com>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

