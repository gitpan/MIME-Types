# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use MIME::Types;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

($mt, $cte) = MIME::Types::by_suffix("Pdf");
print $mt eq "application/pdf" && $cte eq "base64" ? "ok 2\n" :
	"not ok 2\n";

($mt, $cte) = MIME::Types::by_suffix("foo.Pdf");
print $mt eq "application/pdf" && $cte eq "base64" ? "ok 3\n" :
	"not ok 3\n";

($mt, $cte) = MIME::Types::by_suffix("flurfl");
print $mt eq "" && $cte eq "" ? "ok 4\n" : "not ok 4\n";

@c = MIME::Types::by_mediatype("pdF");
print @c == 1 && $c[0]->[0] eq "pdf" && $c[0]->[1] eq "application/pdf" &&
    $c[0]->[2] eq "base64" ? "ok 5\n" : "not ok 5\n";

@c = MIME::Types::by_mediatype("Application/pDF");
print @c == 1 && $c[0]->[0] eq "pdf" && $c[0]->[1] eq "application/pdf" &&
    $c[0]->[2] eq "base64" ? "ok 6\n" : "not ok 6\n";

@c = MIME::Types::by_mediatype("e");
print @c > 1 ? "ok 7\n" : "not ok 7\n";

@c = MIME::Types::by_mediatype("xyzzy");
print @c == 0 ? "ok 8\n" : "not ok 8\n";

# for (@c) { print "@{$_}\n"; }
