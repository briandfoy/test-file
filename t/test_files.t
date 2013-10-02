use strict;

use Test::Builder::Tester;
use Test::More tests => 20; # includes those in t/setup_common
use Test::File;

=pod

max_file       non_zero_file  not_readable   readable       zero_file
executable     min_file       not_executable not_writeable  writeable

=cut

my $test_directory = 'test_files';
SKIP: {
    skip "setup already done", 5 if -d $test_directory;
    require "t/setup_common";
};

chdir $test_directory or print "bail out! Could not change directories: $!";

test_out( 'ok 1 - readable exists' );
file_exists_ok( 'readable' );
test_test();

test_out( 'ok 1 - fooey does not exist' );
file_not_exists_ok( 'fooey' );
test_test();



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
test_out( 'ok 1 - readable is readable' );
file_readable_ok( 'readable' );
test_test();

SKIP: {
skip "Superuser has special privileges", 1, if( $> == 0 or $< == 0 );
test_out( 'ok 1 - writeable is not readable' );
file_not_readable_ok( 'writeable' );
test_test();
};

test_out( 'ok 1 - writeable is writeable' );
file_writeable_ok( 'writeable' );
test_test();

SKIP: {
skip "Superuser has special privileges", 1, if( $> == 0 or $< == 0 );
test_out( 'ok 1 - readable is not writeable' );
file_not_writeable_ok( 'readable' );
test_test();
};


{
my $s = Test::File::_win32()
	? "# skip file_executable_ok doesn't work on Windows!"
	: "- executable is executable";
test_out( "ok 1 $s" );
file_executable_ok( 'executable' );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_not_executable_ok doesn't work on Windows!"
	: "- not_executable is not executable";
test_out( "ok 1 $s" );
file_not_executable_ok( 'not_executable' );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_is doesn't work on Windows!"
	: "- executable mode is 0100";
test_out( "ok 1 $s" );
file_mode_is( 'executable', 0100 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_isnt doesn't work on Windows!"
	: "- executable mode is not 0200";
test_out( "ok 1 $s" );
file_mode_isnt( 'executable', 0200 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_is doesn't work on Windows!"
	: "- readable mode is 0400";
test_out( "ok 1 $s" );
file_mode_is( 'readable', 0400 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_isnt doesn't work on Windows!"
	: "- readable mode is not 0200";
test_out( "ok 1 $s" );
file_mode_isnt( 'readable', 0200 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_is doesn't work on Windows!"
	: "- writeable mode is 0200";
test_out( "ok 1 $s" );
file_mode_is( 'writeable', 0200 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_isnt doesn't work on Windows!"
	: "- writeable mode is not 0100";
test_out( "ok 1 $s" );
file_mode_isnt( 'writeable', 0100 );
test_test();
}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

END {
	chdir '..' or print "bail out! Could not change directories: $!";
	unlink glob( "test_files/*" );
	rmdir "test_files";
}
