package MIME::Types;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw();
@EXPORT_OK = qw( whatis );

$VERSION = '0.02';

my %_default_table = (
	ai => ['application/postscript' , '8bit'],
	aiff => ['audio/x-aiff' , 'base64'],
	au => ['audio/basic' , 'base64'],
	avi => ['video/x-msvideo' , 'base64'],
	bck => ['application/VMSBACKUP' , 'base64'],
	bin => ['application/x-octetstream' , 'base64'],
	bleep => ['application/bleeper' , '8bit'],
	class => ['application/octet-stream' , 'base64'],
	com => ['text/plain' , '8bit'],
	crt => ['application/x-x509-ca-cert' , 'base64'],
	csh => ['application/x-csh' , 'base64'],
	dat => ['text/plain' , '8bit'],
	doc => ['application/msword' , 'base64'],
	dot => ['application/msword' , 'base64'],
	dvi => ['application/x-dvi' , 'base64'],
	eps => ['application/postscript' , '8bit'],
	exe => ['application/octet-stream' , 'base64'],
	gif => ['image/gif' , 'base64'],
	gtar => ['application/x-gtar' , 'base64'],
	gz => ['application/x-gzip' , 'base64'],
	hlp => ['text/plain' , '8bit'],
	hqx => ['application/mac-binhex40' , 'base64'],
	htm => ['text/html' , '8bit'],
	html => ['text/html' , '8bit'],
	htmlx => ['text/html' , '8bit'],
	htx => ['text/html' , '8bit'],
	imagemap => ['application/imagemap' , '8bit'],
	jpe => ['image/jpeg' , 'base64'],
	jpeg => ['image/jpeg' , 'base64'],
	jpg => ['image/jpeg' , 'base64'],
	mcd => ['application/mathcad' , 'base64'],
	mid => ['audio/midi' , 'base64'],
	midi => ['audio/midi' , 'base64'],
	mov => ['video/quicktime' , 'base64'],
	movie => ['video/x-sgi-movie' , 'base64'],
	mpeg => ['video/mpeg' , 'base64'],
	mpe => ['video/mpeg' , 'base64'],
	mpg => ['video/mpeg' , 'base64'],
	pdf => ['application/pdf' , 'base64'],
	ppt => ['application/vnd.ms-powerpoint' , 'base64'],
	ps => ['application/postscript' , '8bit'],
	'ps-z' => ['application/postscript' , 'base64'],
	qt => ['video/quicktime' , 'base64'],
	# Look out!
	rtf => ['text/richtext' , '8bit'],
	rtf => ['application/rtf' , '8bit'],
	#
	rtx => ['text/richtext' , '8bit'],
	sh => ['application/x-sh' , 'base64'],
	sit => ['application/x-stuffit' , 'base64'],
	tar => ['application/x-tar' , 'base64'],
	tif => ['image/tiff' , 'base64'],
	tiff => ['image/tiff' , 'base64'],
	txt => ['text/plain' , '8bit'],
	ua => ['audio/basic' , 'base64'],
	wav => ['audio/x-wav' , 'base64'],
	xls => ['application/vnd.ms-excel' , 'base64'],
	xbm => ['image/x-xbitmap' , '7bit'],
	zip => ['application/zip' , 'base64'],
);

my %_unix_table = (
	%_default_table,
);

my %_windows_table = (
	%_default_table,
);

my %_os2_table = (
	%_default_table,
);

my %_mac_table = (
	%_default_table,
	bin => ['application/x-macbase64'],
);

my %_vms_table = (
	%_default_table,
	doc => ['text/plain' , '8bit'],
);


my %_os_map_table = (
	UNIX => \%_unix_table,
	MACINTOSH => \%_mac_table,
	VMS => \%_vms_table,
	WINDOWS => \%_windows_table,
	OS2 => \%_os2_table,
);

{

# We need to share $OS between the BEGIN time and each call to the various subs

my $OS;

BEGIN {

	# Lifted from CGI.pm

	# Some systems support the $^O variable.  If not
	# available then require() the Config library
	unless ($OS) {
	    unless ($OS = $^O) {
		require Config;
		$OS = $Config::Config{'osname'};
	    }
	}
	if ($OS=~/Win/i) {
	    $OS = 'WINDOWS';
	} elsif ($OS=~/vms/i) {
	    $OS = 'VMS';
	} elsif ($OS=~/Mac/i) {
	    $OS = 'MACINTOSH';
	} elsif ($OS=~/os2/i) {
	    $OS = 'OS2';
	} else {
	    $OS = 'UNIX';
	}
}

my %_table;

# Preloaded methods go here.

sub by_suffix {

	my ($arg) = @_;
	$arg ||= "";

	# Look for a suffix on the file name
	# If there isn't one, assume the argument is the suffix itself

	my ($suffix) = $arg =~ / \.(\w+)$ /x;
	$suffix = $arg unless defined($suffix);

	# Load the types table if it's not already loaded

	if (! %_table) {
		my $table_ref = $_os_map_table{$OS};
		%_table = (ref($table_ref) eq 'HASH') ?
		    %$table_ref : %_default_table;
	}

	my $rv = $_table{lc($suffix)};

	if (defined($rv)) {
		return @$rv;
	} else {
		return ();
	}
}

sub by_mediatype {

	my ($type) = @_;
	my ($key, $aref, $regexp, @rv);

	@rv = ();

	# Load the types table if it's not already loaded

	if (! %_table) {
		my $table_ref = $_os_map_table{$OS};
		%_table = (ref($table_ref) eq 'HASH') ?
		    %$table_ref : %_default_table;
	}

	$type = lc($type);
	if ($type =~ m#/#) {
		$regexp = "^${type}\$";
	} else {
		$regexp = $type;
	}

	while (($key, $aref) = each  %_table) {

		if ($aref->[0] =~ /$regexp/) {
			push(@rv, [$key, $aref->[0], $aref->[1]]);
		}
	}

	return @rv;
}


}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

MIME::Types - Perl extension for determining MIME types and Transfer Encoding

=head1 SYNOPSIS

use MIME::Types;

($media_type, $content_transfer_encoding) = MIME::Types::by_suffix(FILENAME);

@LIST = MIME::Types::by_mediatype(MEDIATYPE);

=head1 DESCRIPTION

NOTE: This is ALPHA code.
There are no guarantees that any of the subroutines described here will
not have their names or return values changed.

This module is built to conform to the MIME types standard defined
in RFC 1341 and updated by RFC's 1521 and 1522.
It follows the collection kept at
F<http://www.ltsw.se/knbase/internet/mime.htp>.

The following functions are available:

=over 4

=item B<by_suffix>

This function takes either a file name suffix or a complete file name.
It returns a two-element list if the suffix can be found:
the media type and a content encoding.
An empty list is returned if the suffix could not be found.

=item B<by_mediatype>

This function takes a media type and returns an array containing
references to a three-element list whose values are
the file name suffix used to identify it, the media type,
and a content encoding.

If the media type contains a slash (/), it is assumed to be a complete
media type and must exactly match against the internal table.
Otherwise the value is simply compared to all the values in the
table.
Thus, calling B<by_mediatype("application")> will return a large list.

=back

=head1 AUTHOR

Jeff Okamoto (F<okamoto@corp.hp.com>).
Inspired by the mail_attach.pl program by
Dan Sugalski (F<dan@sidhe.org>).

=cut
