# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..17\n"; }
END {print "not ok 1\n" unless $loaded;}
use MIME::Types;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

#
# These tests assume you want an array returned
#

($mt, $cte) = MIME::Types::by_suffix("Pdf");
print $mt eq "application/pdf" && $cte eq "base64" ? "ok 2\n" :
	"not ok 2 ($mt $cte)\n";

($mt, $cte) = MIME::Types::by_suffix("foo.Pdf");
print $mt eq "application/pdf" && $cte eq "base64" ? "ok 3\n" :
	"not ok 3 ($mt $cte)\n";

($mt, $cte) = MIME::Types::by_suffix("flurfl");
print $mt eq "" && $cte eq "" ? "ok 4\n" : "not ok 4\n";

@c = MIME::Types::by_mediatype("pdF");
print @c == 1 && $c[0]->[0] eq "pdf" && $c[0]->[1] eq "application/pdf" &&
    $c[0]->[2] eq "base64" ? "ok 5\n" : "not ok 5 (@$c[0])\n";

@c = MIME::Types::by_mediatype("Application/pDF");
print @c == 1 && $c[0]->[0] eq "pdf" && $c[0]->[1] eq "application/pdf" &&
    $c[0]->[2] eq "base64" ? "ok 6\n" : "not ok 6 (@$c[0])\n";

@c = MIME::Types::by_mediatype("e");
print @c > 1 ? "ok 7\n" : "not ok 7 (" . scalar(@c) . ")\n";

@c = MIME::Types::by_mediatype("xyzzy");
print @c == 0 ? "ok 8\n" : "not ok 8\n";

#
# These tests assume you want an array reference returned
#

$aref = MIME::Types::by_suffix("Pdf");
print $aref->[0] eq "application/pdf" && $aref->[1] eq "base64" ? "ok 9\n" :
	"not ok 9 (@$aref)\n";

$aref = MIME::Types::by_suffix("foo.Pdf");
print $aref->[0] eq "application/pdf" && $aref->[1] eq "base64" ? "ok 10\n" :
	"not ok 10 (@$aref)\n";

$aref = MIME::Types::by_suffix("flurfl");
print $aref->[0] eq "" && $aref->[1] eq "" ? "ok 11\n" : "not ok 11 (@$aref)\n";

$aref = MIME::Types::by_mediatype("pdF");
print @$aref == 1 && $aref->[0]->[0] eq "pdf" && $aref->[0]->[1] eq "application/pdf" && $aref->[0]->[2] eq "base64" ? "ok 12\n" : "not ok 12 (@{$aref->[0]})\n";

$aref = MIME::Types::by_mediatype("Application/pDF");
print @$aref == 1 && $aref->[0]->[0] eq "pdf" && $aref->[0]->[1] eq "application/pdf" && $aref->[0]->[2] eq "base64" ? "ok 13\n" : "not ok 13 (@{$aref->[0]})\n";

$aref = MIME::Types::by_mediatype("e");
print @$aref > 1 ? "ok 14\n" : "not ok 14 (" . scalar(@$aref) . ")\n";

$aref = MIME::Types::by_mediatype("xyzzy");
print @$aref == 0 ? "ok 15\n" : "not ok 15 (@$aref)\n";

$aref = MIME::Types::import_mime_types("mime.types");
print $aref == 87 ? "ok 16\n" : "not ok 16 ($aref should be 87)\n";

$aref = MIME::Types::by_suffix("foo.tsv");
print $aref->[0] eq "text/tab-separated-values" && $aref->[1] eq "quoted-printable" ? "ok 17\n" :
	"not ok 17 (@$aref)\n";

