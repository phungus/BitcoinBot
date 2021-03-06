package Bot::BasicBot::Pluggable::Module::Ident;
BEGIN {
  $Bot::BasicBot::Pluggable::Module::Ident = '0.1';
}
use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;
use Crypt::SaltedHash;

sub init {
    my $self = shift;

#    $self->{_ident_commands} = {
#		register	=> '',
#        ident		=> '<password>',
#    };
}

sub help {
    my $self = shift;
    return "Ident command. Supply password if you have one, checks internal db, returns a new one if none supplied and no account.\n"
}


sub told {
    my ( $self, $mess ) = @_;
    my $body = $mess->{body};
    return unless defined $body;
	return unless $body =~ /^!/;
    return unless $mess->{address};

	return "chan: $mess->{channel} who: $mess->{who} address: $mess->{address} body: $body\n";

    my ( $command, $param ) = split( /\s+/, $body, 2 );
    $command = lc($command);
#    return unless $command =~ /^(ident|register|logout)$/;

    return "Identification commands in /msg only, please."
    	unless !defined $mess->{channel} || $mess->{channel} eq 'msg';

	if ($command =~ /^ident/) {
	return "Ident: $body\n";
	}
	
#    if (!$self->authed($mess->{who})) {
#        return "Sorry, you must be authenticated to do that.";
#    }

#    if ( $command eq "join" ) {
#        $self->add_channel($param);
#        return "Ok.";
#	 } 
}


sub ident {
    my ( $self, $mess ) = @_;
    my $body = $mess->{body};
	print "Ident event: $body\n";
    
	# we don't care about commands that don't start with '!'.
    return 0 unless $body =~ /^!/;

    # ident commands have to be directly addressed...
	return 1 unless $mess->{address};

    # ...and in a privmsg.
    return "Identification commands in /msg only, please."
    	unless !defined $mess->{channel} || $mess->{channel} eq 'msg';

	return "Ident: $body\n";
}

sub idented {
    my ( $self, $username ) = @_;
    return 1
      if (  $self->{auth}{$username}{time}
        and $self->{auth}{$username}{time} + 7200 > time() );
    return 0;
}

# Given a password provided by the user and the password stored in the database,
# see if they match.  Older versions stored plaintext passwords, newer versions
# use salted hashed passwords.
sub _check_password {
    my ($entered_pw, $stored_pw) = @_;
    return unless defined $entered_pw && defined $stored_pw;
    if ($stored_pw =~ /^\{SSHA\}/) {
        return Crypt::SaltedHash->validate($stored_pw, $entered_pw);
    } else {
        return $entered_pw eq $stored_pw;
    }
}

# Given a plain-text password, return a salted hashed version to store
sub _hash_password {
    my $plain_pw = shift;
    my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-1');
    $csh->add($plain_pw);
    return $csh->generate;
}

1;
__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Auth - authentication for Bot::BasicBot::Pluggable modules

=head1 VERSION

version 0.93

=head1 SYNOPSIS

This module catches messages at priority 1 and stops anything starting
with '!' unless the user is authed. Most admin modules, e.g. Loader, can
merely sit at priority 2 and assume the user is authed if the !command
reaches them. If you want to use modules that can change bot state, like
Loader or Vars, you almost certainly want this module.

=head1 IRC USAGE

The default user is 'admin' with password 'julia'. Change this.

=over 4

=item !auth <username> <password>

Authenticate as an administrators. Logins timeout after an hour.

=item !adduser <username> <password>

Adds a user with the given password.

=item !deluser <username>

Deletes a user. Don't delete yourself, that's probably not a good idea.

=item !password <old password> <new password>

Change your current password (must be logged in first).

=item !users

List all the users the bot knows about.

=back

=head1 VARIABLES

=over 4

=item password_admin

This variable specifies the admin password. Its normally set via the
!password directive and defaults to 'julia'. Please change this as soon
as possible.

=item allow_anonymous

If this variable is true, the implicit authentication handling is
disabled. Every module will have to check for authentication via the
authed method, otherwise access is just granted. This is only usefull
to allow modules to handle directives starting with an exclamation
mark without needing any authentication. And to make things even more
interesting, you won't be warned that you have't authenticated, so modules
needing authentication will fail without any warning. It defaults to
false and should probably never be changed. You've been warned.

=back

=head1 METHODS

The only useful method is C<authed()>:

=over 4

=item authed($username)

Returns 1 if the given username is logged in, 0 otherwise:

  if ($bot->module("Auth")->authed("jerakeen")) { ... }

=back

=head1 BUGS

All users are admins. This is fine at the moment, as the only things that need
you to be logged in are admin functions. Passwords are stored in plaintext, and
are trivial to extract for any module on the system. I don't consider this a
bug, because I assume you trust the modules you're loading. If Auth is I<not>
loaded, all users effectively have admin permissions. This may not be a good
idea, but is also not an Auth bug, it's an architecture bug.

=head1 AUTHOR

Mario Domgoergen <mdom@cpan.org>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.
