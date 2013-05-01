package Bot::BasicBot::Pluggable::Module::Stocks;

use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use Finance::Quote;

our $VERSION = '0.1';


sub init {
    my $self = shift;

}

sub help {
    return "Stock Ticker: .s [Symbol] - Returns USA market stock quote ";
}

sub told {
	my ($self, $mess) = @_;
	my $body = $mess->{body};
	return 0 unless defined $body;
	
	if ($body =~ /^\.s [A-Za-z0-9]{1,4}$/) {
		my $symbol = $body;
		$symbol =~ s/^\.s\s//;

		my $q = Finance::Quote->new();
		my %s = $q->fetch('usa', $symbol);

		if ($s{$symbol, 'success'}) {
			my $name = $s{$symbol,'name'};
			my $quote = $s{$symbol,'price'};
			my $high = $s{$symbol,'high'};
			my $low = $s{$symbol,'low'};
			my $vol = $s{$symbol,'volume'};
			my $avgvol = $s{$symbol,'avg_vol'};
			my $pe = $s{$symbol,'pe'};
			return "Symbol: $symbol - $name - Last: $quote (High: $high, Low: $low) Vol: $vol (Avg: $avgvol)";
		}
		else {
			my $error = $s{$symbol, 'errormsg'};
			return "Unknown symbol or other error: $error";
		}
	}
}


1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Sticks - Stock Quote

=head1 VERSION

version 0.1

=head1 IRC USAGE

=over 4

=item .s [Symbol]

Get quote for [Symbol]

=back

=head1 VARS

=over 4

=item None implemented

=back

=head1 AUTHOR

phungus <phungus@gmx.com>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

