use strict;

use Test::Builder::Tester;
use Test::More tests => 19; # includes those in t/setup_common
use Test::File;

my $test_directory = 'test_files';
SKIP: {
    skip "setup already done", 5 if -d $test_directory;
    require "t/setup_common";
};

chdir $test_directory or print "bail out! Could not change directories: $!";

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Subroutines are defined
ok( defined &Test::File::_dm_skeleton, "_dm_skeleton is defined" );

my $readable  = 'readable';
my $not_there = 'not_there';
my $test_name = 'This is my test name';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Fake a non-multi-user OS
{
local $^O = 'dos';
ok( Test::File::_obviously_non_multi_user(), "Is not multi user" );

is( Test::File::_dm_skeleton(),           'skip', "Skip on single user systems" );
is( Test::File::_dm_skeleton($readable),  'skip', "Skip on single user systems" );
is( Test::File::_dm_skeleton($not_there), 'skip', "Skip on single user systems" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Fake a multi-user OS with existing file
{
local $^O = 'MSWin32';
diag "$^O\n";;
ok( ! Test::File::_obviously_non_multi_user(), "Is multi user" );



}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Fake a multi-user OS with non-existing file
{
local $^O = 'MSWin32';
ok( ! Test::File::_obviously_non_multi_user(), "Is multi user" );

test_out( "not ok 1" );
test_diag(
	"File [$not_there] does not exist!\n" .
	"#   Failed test at $0 line " . line_num(+4) . "."
	);
Test::File::_dm_skeleton( $not_there );
test_test();
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Fake a multi-user OS with no argument
{
local $^O = 'MSWin32';
ok( ! Test::File::_obviously_non_multi_user(), "Is multi user" );

test_out( "not ok 1" );
test_diag(
	"File name not specified!\n" .
	"#   Failed test at $0 line " . line_num(+4) . "."
	);
Test::File::_dm_skeleton();
test_test();
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

END {
	chdir '..' or print "bail out! Could not change directories: $!";
	unlink glob( "test_files/*" );
	rmdir "test_files";
}
