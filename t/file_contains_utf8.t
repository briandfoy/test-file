use strict;
use warnings;
use utf8;

use Test::Builder::Tester;
use Test::More 0.88;
use Test::File;

# Hello world from utf8 test file:
# http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-test.txt
my $string1 = 'Καλημέρα κόσμε';
my $string2 = 'コンニチハ';

my $test_directory = 'test_files';
unless( -d 'test_files' )
    {
    mkdir 'test_files', 0700
        or print "bail out! Could not make directory! $!";
    }

chdir $test_directory or print "bail out! Could not change directories: $!";

my $file = 'utf8_file';
open my $fh, '>', $file or print "bail out! Could not write to utf8_file: $!";
$fh->binmode(':encoding(UTF-8)');
$fh->print("$string1$/$/$/");
$fh->print("$string2$/");
$fh->close;

my $contents = do {
    open $fh, '<', $file;
    $fh->binmode(':encoding(UTF-8)');
    local $/;
    <$fh>;
};
$fh->close;

my $pattern1 = qr/(?mu:^$string1$)/;
my $pattern2 = qr/(?mu:^$string2$)/;
my $bad_pattern = 'x' x 20; $bad_pattern = qr/(?mu:^$bad_pattern$)/;

# like : single pattern

test_out( "ok 1 - utf8_file contains $pattern1" );
file_contains_utf8_like( $file, $pattern1 );
test_test();

test_out( "not ok 1 - utf8_file contains $bad_pattern" );
test_fail(+2);
like_diag($contents, $bad_pattern, "doesn't match");
file_contains_utf8_like( 'utf8_file', $bad_pattern );
test_test();

# unlike : single pattern

test_out( "ok 1 - utf8_file doesn't contain $bad_pattern" );
file_contains_utf8_unlike( $file, $bad_pattern );
test_test();

test_out( "not ok 1 - utf8_file doesn't contain $pattern1" );
test_fail(+2);
like_diag($contents, $pattern1, "matches");
file_contains_utf8_unlike( 'utf8_file', $pattern1 );
test_test();

# like : multiple patterns

test_out( "ok 1 - utf8_file contains $pattern1" );
test_out( "ok 2 - utf8_file contains $pattern2" );
file_contains_utf8_like( $file, [ $pattern1, $pattern2 ] );
test_test();

test_out( "ok 1 - file has the goods" );
test_out( "ok 2 - file has the goods" );
file_contains_utf8_like( $file, [ $pattern1, $pattern2 ], 'file has the goods' );
test_test();

test_out( "ok 1 - utf8_file contains $pattern1" );
test_out( "not ok 2 - utf8_file contains $bad_pattern" );
test_fail(+2);
like_diag($contents, $bad_pattern, "doesn't match");
file_contains_utf8_like( 'utf8_file', [ $pattern1, $bad_pattern ] );
test_test();

# unlike : multiple patterns

test_out( "ok 1 - utf8_file doesn't contain $bad_pattern" );
test_out( "ok 2 - utf8_file doesn't contain $bad_pattern" );
file_contains_utf8_unlike( $file, [ $bad_pattern, $bad_pattern ] );
test_test();

test_out( "ok 1 - file has the goods" );
test_out( "ok 2 - file has the goods" );
file_contains_utf8_unlike( $file, [ $bad_pattern, $bad_pattern ], 'file has the goods' );
test_test();

test_out( "ok 1 - utf8_file doesn't contain $bad_pattern" );
test_out( "not ok 2 - utf8_file doesn't contain $pattern1" );
test_fail(+2);
like_diag($contents, $pattern1, "matches");
file_contains_utf8_unlike( 'utf8_file', [ $bad_pattern, $pattern1 ] );
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
	my ($string, $pattern, $verb) = @_;

	my $diag = ' ' x 18 . "'$string'\n";
	$diag .= sprintf("%17s '%s'", $verb, $pattern);
	$diag =~ s/^/# /mg;

	test_err($diag);
}
