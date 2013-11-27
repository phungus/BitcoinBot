package Bot::BasicBot::Pluggable::Module::Ticker;

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use WebService::MtGox;
use LWP::Simple;
use JSON qw( decode_json );

our $VERSION = '0.1';


sub init {
    my $self = shift;

}

sub help {
    return "Ticker commands: .t - MTGox Current Price";
}

sub told {
	my ($self, $mess) = @_;
	my $body = $mess->{body};
	return 0 unless defined $body;
	#return if !$self->bot->module->ident( $mess->{who} );
	#return unless $mess->{address};
	
<<<<<<< HEAD
	if ($body =~ /^.tg$/) {
=======
	if ($body =~ /^\.t$/) {
>>>>>>> e8e416000c532cd831fe973d3385e67e13d3d6ac
		my $m = WebService::MtGox->new;
		my $t = $m->get_ticker;
		
		my $last = $t->{return}->{last}->{value};
		my $vol = $t->{return}->{vol}->{value};
		my $high = $t->{return}->{high}->{value};
		my $low = $t->{return}->{low}->{value};
		my $buy = $t->{return}->{buy}->{value};
		my $sell = $t->{return}->{sell}->{value};

		my $spread = $buy > $sell ? $buy - $sell : $sell - $buy;
		my $pspread = sprintf("%0.5f", $spread);

		return "[MtGox] Last: $last :: 24h Volume: $vol  High: $high  Low: $low :: Buy: $buy  Sell: $sell  Spread: $pspread";

	}
	elsif ($body =~ /^.tc$/) {
		my $url = "https://coinbase.com/api/v1/prices/buy";
		my $res = `/usr/bin/curl -sf $url`;
		return "No Data from Coinbase" unless defined $res;
		my $m = decode_json($res);
		my $last = $m{"amount"};
		return "Last: $last";		
	}

}


1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Ticker - MTGox Ticker for Bitcoin/USD Exchange information

=head1 VERSION

version 0.1

=head1 IRC USAGE

=over 4

=item .t

Get current MtGox Ticker API info 

=back

=head1 VARS

=over 4

=item None implemented

=back

=head1 AUTHOR

phungus <phungus@gmx.com>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

