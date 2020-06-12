use strict;

use Test::Builder::Tester;
use Test::More 0.95;
use Test::File;

=pod

max_file       non_zero_file  not_readable   readable       zero_file
executable     min_file       not_executable not_writable   writable

=cut

require "./t/setup_common";

diag "Warnings about file_writeable_ok are fine. It's a deprecated name that still works.";

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
test_out( 'ok 1 - writable is not readable' );
file_not_readable_ok( 'writable' );
test_test();
};

test_out( 'ok 1 - writable is writable' );
file_writable_ok( 'writable' );
test_test();

test_out( 'ok 1 - writable is writable' );
file_writeable_ok( 'writable' );
test_test();

SKIP: {
skip "Superuser has special privileges", 1, if( $> == 0 or $< == 0 );
test_out( 'ok 1 - readable is not writable' );
file_not_writable_ok( 'readable' );
test_test();

test_out( 'ok 1 - readable is not writable' );
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
	? "# skip file_mode_has doesn't work on Windows!"
	: "- executable mode has all bits of 0100";
test_out( "ok 1 $s" );
file_mode_has( 'executable', 0100 );
test_test();
}

{
if (Test::File::_win32)
  {
    test_out( "ok 1 # skip file_mode_has doesn't work on Windows!" );
    file_mode_has( 'executable', 0111 );
  }
else
  {
    test_out( "not ok 1 - executable mode has all bits of 0111" );
    test_diag("File [executable] mode is missing component 0011!");
    test_diag("  Failed test 'executable mode has all bits of 0111'");
    test_diag("  at " . __FILE__ . " line " . (__LINE__+1) . ".");
    file_mode_has( 'executable', 0111 );
  }
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
	? "# skip file_mode_hasnt doesn't work on Windows!"
	: "- executable mode has no bits of 0200";
test_out( "ok 1 $s" );
file_mode_hasnt( 'executable', 0200 );
test_test();
}

{
if (Test::File::_win32())
  {
    test_out( "ok 1 # skip file_mode_hasnt doesn't work on Windows!" );
    file_mode_hasnt( 'executable', 0111 );
  }
else
  {
    test_out( "not ok 1 - executable mode has no bits of 0111" );
    test_diag("File [executable] mode has forbidden component 0100!");
    test_diag("  Failed test 'executable mode has no bits of 0111'");
    test_diag("  at " . __FILE__ . " line " . (__LINE__+1) . ".");
    file_mode_hasnt( 'executable', 0111 );
  }
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
	: "- writable mode is 0200";
test_out( "ok 1 $s" );
file_mode_is( 'writable', 0200 );
test_test();
}

{
my $s = Test::File::_win32()
	? "# skip file_mode_isnt doesn't work on Windows!"
	: "- writable mode is not 0100";
test_out( "ok 1 $s" );
file_mode_isnt( 'writable', 0100 );
test_test();
}

done_testing();
