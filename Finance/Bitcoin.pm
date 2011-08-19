package Finance::Bitcoin;

use Finance::Bitcoin::API;
use Finance::Bitcoin::Wallet;
use Finance::Bitcoin::Address;

our $VERSION = '0.002';

1;

__END__

=head1 NAME

Finance::Bitcoin - manage a bitcoin instance

=head1 DESCRIPTION

Bitcoin is a peer-to-peer network based digital currency.

This module provides high and low level APIs for managing a running
bitcoin instance over JSON-RPC.

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<Finance::Bitcoin::API>,
L<Finance::Bitcoin::Wallet>,
L<Finance::Bitcoin::Address>.

L<http://www.bitcoin.org/>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2010 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

