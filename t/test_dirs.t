use strict;
use warnings;

use Test::Builder::Tester;
use Test::More 0.88;
use Test::File;


my $test_directory = 'test_files';
require "t/setup_common" unless -d $test_directory;

chdir $test_directory or print "bail out! Could not change directories: $!";
mkdir 'test_dir', 0700;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

test_out( 'ok 1 - test_dir is a directory' );
dir_exists_ok( 'test_dir' );
test_test();

test_out( 'not ok 1 - bmoogle is a directory' );
test_diag( 'File [bmoogle] does not exist!' );
test_fail(+1);
dir_exists_ok( 'bmoogle' );
test_test();

test_out( 'not ok 1 - readable is a directory' );
test_diag( 'File [readable] exists but is not a directory!' );
test_fail(+1);
dir_exists_ok( 'readable' );
test_test();


done_testing();


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

chdir '..' or print "bail out! Could not change directories: $!";

END {
	unlink glob( "test_files/*" );
	rmdir "test_files/test_dir";
	rmdir "test_files";
}
