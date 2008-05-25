# $Id$
use strict;

use Test::Builder::Tester;
use Test::More tests => 37; # includes those in t/setup_common
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

test_out( 'ok 1 - zero_file is empty' );
file_empty_ok( 'zero_file' );
test_test();

test_out( 'ok 1 - min_file is not empty' );
file_not_empty_ok( 'min_file' );
test_test();

test_out( 'ok 1 - min_file has right size' );
file_size_ok( 'min_file', 53 );
test_test();

test_out( 'ok 1 - min_file is under 54 bytes' );
file_max_size_ok( 'min_file', 54 );
test_test();

test_out( 'ok 1 - min_file is over 50 bytes' );
file_min_size_ok( 'min_file', 50 );
test_test();

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Line count
SKIP: {
my $file  = 'min_file';

diag( "min_file doesn't exist" )  unless -e $file;
diag( "min_file isn't readable" ) unless -r $file;

my $tests = 8;
#unlink $file;

skip "$file is missing!", $tests unless -r $file;

my $lines  = 2;
my $linesm = $lines - 1;
my $linesp = $lines + 1;

test_out( "ok 1 - $file line count is $lines lines" );
file_line_count_is( $file, $lines );
test_test();

my $name = "$file line count is $linesp lines";
test_out( "not ok 1 - $name" );
test_diag( 
	"Expected [3] lines in [$file], got [$lines] lines\n" .
	"#   Failed test '$name'\n" . 
	"#   at $0 line " . line_num(+5) . "." 
	);
file_line_count_is( $file, $linesp );
test_test();

test_out( "ok 1 - $file line count is not $linesp lines" );
file_line_count_isnt( $file, $linesp );
test_test();

$name = "$file line count is not $lines lines";
test_out( "not ok 1 - $name" );
test_diag( 
	"Expected something other than [$lines] lines in [$file], but got [$lines] lines\n" .
	"#   Failed test '$name'\n" . 
	"#   at $0 line " . line_num(+5) . "." 
	);
file_line_count_isnt( $file, $lines );
test_test();

test_out( "ok 1 - $file line count is between [$linesm] and [$linesp] lines" );
file_line_count_between( $file, $linesm, $linesp );
test_test();

test_out( "ok 1 - $file line count is between [$lines] and [$linesp] lines" );
file_line_count_between( $file, $lines, $linesp );
test_test();

test_out( "ok 1 - $file line count is between [$lines] and [$lines] lines" );
file_line_count_between( $file, $lines, $lines );
test_test();

$name = "$file line count is between [$linesp] and [@{[$linesp+1]}] lines";
test_out( "not ok 1 - $name" );
test_diag( 
	"Expected a line count between [$linesp] and [@{[$linesp+1]}] in [$file], but got [$lines] lines\n" .
	"#   Failed test '$name'\n" . 
	"#   at $0 line " . line_num(+4) . "." 
	);
file_line_count_between( $file, $linesp, $linesp + 1 );
test_test();

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
test_out( 'ok 1 - readable is readable' );
file_readable_ok( 'readable' );
test_test();

SKIP: {
skip "Superuser has special priveleges", 1, if( $> == 0 or $< == 0 );
test_out( 'ok 1 - writeable is not readable' );
file_not_readable_ok( 'writeable' );
test_test();
};

test_out( 'ok 1 - writeable is writeable' );
file_writeable_ok( 'writeable' );
test_test();

SKIP: {
skip "Superuser has special priveleges", 1, if( $> == 0 or $< == 0 );
test_out( 'ok 1 - readable is not writeable' );
file_not_writeable_ok( 'readable' );
test_test();
};


{
my $s = Test::File::_win32()
	? "# skip file_executable_ok doesn't work on Windows"
	: "- executable is executable";
test_out( "ok 1 $s" );
file_executable_ok( 'executable' );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_not_executable_ok doesn't work on Windows"
	: "- not_executable is not executable";
test_out( "ok 1 $s" );
file_not_executable_ok( 'not_executable' );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_is doesn't work on Windows"
	: "- executable mode is 0100";
test_out( "ok 1 $s" );
file_mode_is( 'executable', 0100 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_isnt doesn't work on Windows"
	: "- executable mode is not 0200";
test_out( "ok 1 $s" );
file_mode_isnt( 'executable', 0200 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_is doesn't work on Windows"
	: "- readable mode is 0400";
test_out( "ok 1 $s" );
file_mode_is( 'readable', 0400 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_isnt doesn't work on Windows"
	: "- readable mode is not 0200";
test_out( "ok 1 $s" );
file_mode_isnt( 'readable', 0200 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_is doesn't work on Windows"
	: "- writeable mode is 0200";
test_out( "ok 1 $s" );
file_mode_is( 'writeable', 0200 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_isnt doesn't work on Windows"
	: "- writeable mode is not 0100";
test_out( "ok 1 $s" );
file_mode_isnt( 'writeable', 0100 );
test_test();
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
my $can_symlink = eval { symlink("",""); 1 };

{
my $s = ! $can_symlink
	? "# skip file_is_symlink_ok doesn't work on systems without symlinks"
	: "- readable_sym is a symlink";

file_exists_ok( "readable" );
file_not_exists_ok( "readable_sym" );

if( $can_symlink )
	{
	symlink( "readable", "readable_sym" );
	file_exists_ok( "readable_sym" );
	}
else
	{
	pass();
	}

test_out( "ok 1 $s" );
file_is_symlink_ok( "readable_sym" );
test_test();
}


chdir '..' or print "bail out! Could not change directories: $!";

END {
unlink glob( "test_files/*" );
rmdir "test_files";
}
