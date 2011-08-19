package Finance::Bitcoin::API;

use Class::Accessor 'antlers';
use JSON::RPC::Client;
use Scalar::Util qw[blessed];

our $VERSION = '0.002';

has endpoint => (is => 'rw');
has jsonrpc  => (is => 'rw');
has error    => (is => 'rw');

sub new
{
	my ($class, %args) = @_;
	$args{endpoint} ||= 'http://127.0.0.1:8332/';
	$args{jsonrpc}  ||= JSON::RPC::Client->new;
	bless \%args, $class;
}

sub call
{
	my ($self, $method, @params) = @_;
	
	my $return = $self->jsonrpc->call($self->endpoint, {
		method    => $method,
		params    => \@params,
		});
	
	if (blessed($return) and $return->can('is_success') and $return->is_success)
	{
		$self->error(undef);
		return $return->result;
	}
	elsif (blessed($return) and $return->can('error_message'))
	{
		$self->error($return->error_message);
		return;
	}
	else
	{
		$self->error(sprintf('HTTP %s', $self->jsonrpc->status_line));
		return;
	}
}

1;

__END__

=head1 NAME

Finance::Bitcoin::API - wrapper for the Bitcoin JSON-RPC API

=head1 SYNOPSIS

 use Finance::Bitcoin::API;
 
 my $uri     = 'http://user:password@127.0.0.1:8332/';
 my $api     = Finance::Bitcoin::API->new( endpoint => $uri );
 my $balance = $api->call('getbalance');
 print $balance;

=head1 DESCRIPTION

This module provides a low-level API for accessing a running
Bitcoin instance.

=over 4

=item C<< new( %args ) >>

Constructor. %args is a hash of named arguments. You need to provide the
'endpoint' URL as an argument.

=item C<< call( $method, @params ) >>

Call a method. If successful returns the result; otherwise returns undef.

=item C<< error >>

Returns the error message (if any) that resulted from the last C<call>.

=back

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<Finance::Bitcoin>.

L<http://www.bitcoin.org/>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2010 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

