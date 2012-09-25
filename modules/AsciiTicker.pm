package Bot::BasicBot::Pluggable::Module::AsciiTicker;

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use WebService::MtGox;

our $VERSION = '0.1';


sub init {
    my $self = shift;

}

sub help {
    return "Ascii Ticker commands: .at - MTGox Current Price";
}

sub told {
	my ($self, $mess) = @_;
	my $body = $mess->{body};
	return 0 unless defined $body;

	# return if !$self->bot->module->ident( $mess->{who} );
	# return unless $mess->{address};
	
	if ($body =~ /^\.at$/) {
		my $m = WebService::MtGox->new;
		my $t = $m->get_ticker;
		
		my $last = $t->{ticker}->{last};
		my $vol = $t->{ticker}->{vol};
		my $high = $t->{ticker}->{high};
		my $low = $t->{ticker}->{low};
		my $buy = $t->{ticker}->{buy};
		my $sell = $t->{ticker}->{sell};
		my $spread = $buy > $sell ? $buy - $sell : $sell - $buy;
		my $pspread = sprintf("%0.5f", $spread);

		my $tout = `figlet -k -f standard "$last"`;
		$tout =~ s/^\ /\.\.\./;
		return $tout;
	}
}


1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::AsciiTicker - MTGox Ticker for Bitcoin/USD Exchange information

=head1 VERSION

version 0.1

=head1 IRC USAGE

=over 4

=item .t

Get current MtGox Ticker API info presented in Ascii numbers.

=back

=head1 VARS

=over 4

=item None implemented

=back

=head1 AUTHOR

phungus <phungus@gmx.com>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

