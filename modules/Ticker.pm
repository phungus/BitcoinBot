package Bot::BasicBot::Pluggable::Module::Ticker;

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use WebService::MtGox;
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
	
	if ($body =~ /^\.t.g$/) {
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
	elsif ($body =~ /^.t.c$/) {
		my $url = "https://coinbase.com/api/v1/prices/buy";
		my $res = `/usr/bin/curl -sf $url`;
		return "No Data from Coinbase" unless defined $res;
		my $m = decode_json($res);
		my $last = $m->{"amount"};
		my $wfee = $m->{"subtotal"}->{"amount"};
		return "[Coinbase] Last: $last - Including Fees: $wfee";		
	}
	elsif ($body =~ /^.t.b$/) {
                my $url = "https://www.bitstamp.net/api/ticker/";
                my $res = `/usr/bin/curl -sf $url`;
                return "No Data from BitStamp" unless defined $res;
                my $m = decode_json($res);
                my $last = $m->{"last"};
                my $high = $m->{"high"};
		my $low = $m->{"low"};
		my $vol = $m->{"volume"};
		my $bid = $m->{"bid"};
		my $ask = $m->{"ask"};
		my $spread = $bid > $ask ? $bid - $ask : $ask - $bid;
		my $pspread = sprintf("%0.5f", $spread);

                return "[Bitstamp] Last: $last :: 24h Volume: $vol  High: $high  Low: $low :: Bid: $bid  Ask: $ask  Spread: $pspread";
        }
	elsif ($body =~ /^.t$/) {
		my $goxlast = &_last_gox;
		my $cblast = &_last_cb;
		my $bslast = &_last_bs;

		return "[MtGox] $goxlast  ::  [Coinbase] $cblast  ::  [Bitstamp] $bslast";
	}


}


sub _last_gox {
                my $m = WebService::MtGox->new;
                my $t = $m->get_ticker;
                my $last = $t->{return}->{last}->{value};
		return $last;
}


sub _last_cb {
                my $url = "https://coinbase.com/api/v1/prices/buy";
                my $res = `/usr/bin/curl -sf $url`;
                return "No Data from Coinbase" unless defined $res;
                my $m = decode_json($res);
                my $last = $m->{"amount"};
                return $last;

}


sub _last_bs {
		my $url = "https://www.bitstamp.net/api/ticker/";
		my $res = `/usr/bin/curl -sf $url`;
		return "No Data from BitStamp" unless defined $res;
		my $m = decode_json($res);
		my $last = $m->{"last"};
		return $last;
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

