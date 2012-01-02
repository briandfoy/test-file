use strict;
use warnings;

use Test::Builder::Tester;
use Test::More 0.88;
use Test::File;


my $test_directory = 'test_files';
require "t/setup_common" unless -d $test_directory;

chdir $test_directory or print "bail out! Could not change directories: $!";


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

my $file = 'min_file';
my $contents = do { open FH, $file; local $/; <FH> }; close FH;
my $pattern1    = 'x' x 11; $pattern1    = qr/^ $pattern1    $/mx;
my $pattern2    = 'x' x 40; $pattern2    = qr/^ $pattern2    $/mx;
my $bad_pattern = 'x' x 20; $bad_pattern = qr/^ $bad_pattern $/mx;

test_out( "ok 1 - min_file contains $pattern1" );
file_contains_like( $file, $pattern1 );
test_test();

test_out( "not ok 1 - bmoogle contains $pattern1" );
test_diag( 'File [bmoogle] does not exist!' );
test_fail(+1);
file_contains_like( 'bmoogle', $pattern1 );
test_test();

test_out( "not ok 1 - not_readable contains $pattern1" );
test_diag( 'File [not_readable] is not readable!' );
test_fail(+1);
file_contains_like( 'not_readable', $pattern1 );
test_test();

test_out( "not ok 1 - min_file contains $bad_pattern" );
test_fail(+2);
like_diag($contents, $bad_pattern);
file_contains_like( 'min_file', $bad_pattern );
test_test();


done_testing();


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

END {
	chdir '..' or print "bail out! Could not change directories: $!";
	unlink glob( "test_files/*" );
	rmdir "test_files";
}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

sub like_diag
{
	my ($string, $pattern) = @_;

	my $diag = ' ' x 18 . "'$string'\n";
	$diag .= ' ' x 4 . "doesn't match '$pattern'";
	$diag =~ s/^/# /mg;

	test_err($diag);
}
