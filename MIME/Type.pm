package MIME::Type;

$VERSION = '0.13';

use strict;
use Carp;

=head1 NAME

 MIME::Type - Definition of one MIME type

=head1 SYNOPSIS

 use MIME::Types;
 my $mimetypes = MIME::Types->new;
 my MIME::Type $plaintext = $mimetype->type('text/plain');
 print $plaintext->mainType;    # text
 print $plaintext->subType;     # plain

 my @ext = $plaintext->extensions;
 print "@ext"                   # asc txt c cc h hh cpp

 print $plaintext->encoding     # 8bit
 if($plaintext->isBinary)       # false
 if($plaintext->isAscii)        # true

 print MIME::Type->simplified('x-appl/x-zip') #  'appl/zip'

=head1 DESCRIPTION

MIME types are used in MIME entities, for instance as part of e-mail
and HTTP traffic.  Sometimes real knowledge about a mime-type is need.
Objects of C<MIME::Type> store the information on one such type.

This module is built to conform to the MIME types standard defined in RFC 1341
and updated by RFC's 1521 and 1522. It follows the collection kept at
F<http://www.ltsw.se/knbase/internet/mime.htp>

=cut

#-------------------------------------------

=head1 METHODS

=over 4

=cut

#-------------------------------------------

=item new OPTIONS

Create a new C<MIME::Type> object which manages one mime type.

 OPTION                    DEFAULT
 type                      <obligatory>
 simplified                <derived from type>
 extensions                undef
 encoding                  <depends on type>
 system                    undef

=over 4

=item * type =E<gt> STRING

The type which is defined here.  It consists of a I<type> and a I<sub-type>,
both case-insensitive.  This module will return lower-case, but accept
upper-case.

=item * simplified =E<gt> STRING

The mime types main- and sub-label can both start with C<x->, to indicate
that is a non-registered name.  Of course, after registration this flag
can disappear which adds to the confusion.  The simplified string has the
C<x-> thingies removed and are translated to lower-case.

=item * extensions =E<gt> REF-ARRAY

An array of extensions which are using this mime.

=item * encoding =E<gt> '7bit'|'8bit'|'base64'|'quoted-printable'

How must this data be encoded to be transported safely.  The default
depends on the type: mimes with as main type C<text/> will default
to C<quoted-printable> and all other to C<base64>.

=item * system =E<gt> REGEX

Regular expression which defines for which systems this rule is valid.  The
REGEX is matched on C<$^O>.

=back

=cut

sub new(@) { (bless {}, shift)->init( {@_} ) }

sub init($)
{   my ($self, $args) = @_;

    $self->{MT_type}       = $args->{type}
       or confess "Type is obligatory.";

    $self->{MT_simplified} = $args->{simplified}
       || ref($self)->simplified($args->{type});

    $self->{MT_extensions} = $args->{extensions} || [];

    $self->{MT_encoding}
       = $args->{encoding}         ? $args->{encoding}
       : $self->mainType eq 'text' ? 'quoted-printable'
       :                             'base64';

    $self->{MT_system}     = $args->{system}
       if defined $args->{system};

    $self;
}

#-------------------------------------------

=item type

Returns the long type of this object, for instance C<'text/plain'>

=cut

sub type() {shift->{MT_type}}

#-------------------------------------------

=item simplified [STRING]

(Instance method or Class method)
Returns the simplified mime type for this object or the specified STRING.
Mime type names can get officially registered.  Until then, they have to
carry an C<x-> preamble to indicate that.  Of course, after recognition,
the C<x-> can disappear.  In many cases, we prefer the simplified version
of the type.

Examples:

 my $mime = MIME::Type->new(type => 'x-appl/x-zip');
 print $mime->simplified;                     # 'appl/zip'
 print $mime->simplified('text/plain');       # 'text/plain'
 print MIME::Type->simplified('x-xyz/x-abc'); # 'xyz/abc'

=cut

sub simplified(;$)
{   my $thing = shift;
    return $thing->{MT_simplified} unless @_;

      shift =~ m!^\s*(?:x\-)?([\w.+-]+)/(?:x\-)?([\w.+-]+)\s*$!
    ? lc "$1/$2" : undef;
}

#-------------------------------------------

=item mainType

The main type of the simplified mime.
For C<'text/plain'> it will return C<'text'>.

=cut

sub mainType() {shift->{MT_simplified} =~ m!^([\w-]+)/! ? $1 : undef}

#-------------------------------------------

=item subType

The sub type of the simplified mime.
For C<'text/plain'> it will return C<'plain'>.

=cut

sub subType() {shift->{MT_simplified} =~ m!/([\w-]+)$! ? $1 : undef}

#-------------------------------------------

=item extensions

Returns a list of extensions which are known to be used for this
mime type.

=cut

sub extensions() { @{shift->{MT_extensions}} }

#-------------------------------------------

=item encoding

Returns the type of encoding which is required to transport data of this
type safely.

=cut

sub encoding() {shift->{MT_encoding}}

#-------------------------------------------

=item system

Returns the regular expression which can be used to determine whether this
type is active on the system where you are working on.

=cut

sub system() {shift->{MT_system}}

#-------------------------------------------

=item isBinary

Returns true when the encoding is base64.

=cut

sub isBinary() { shift->{MT_encoding} eq 'base64' }

#-------------------------------------------

=item isAscii

Returns false when the encoding is base64, and true otherwise.  All encodings
except base64 are text encodings.

=cut

sub isAscii() { shift->{MT_encoding} ne 'base64' }

#-------------------------------------------

=item isSignature

Returns true when the type is in the list of known signatures.

=cut

# simplified names only!
my %sigs = map { ($_ => 1) }
  qw(application/pgp-keys application/pgp application/pgp-signature
     application/pkcs10 application/pkcs7-mime application/pkcs7-signature
     text/vCard);

sub isSignature() { $sigs{shift->{MT_simplified}} }

#-------------------------------------------

=back

=head1 SEE ALSO

L<MIME::Types>

=head1 AUTHOR

Mark Overmeer (F<mimetypes@overmeer.net>).
All rights reserved.  This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 VERSION

This code is beta version 0.13.

Copyright (c) 2001 Mark Overmeer. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
