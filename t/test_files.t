use strict;

use Test::Builder::Tester;
use Test::More 0.95;
use Test::File;

=pod

max_file       non_zero_file  not_readable   readable       zero_file
executable     min_file       not_executable not_writeable  writeable

=cut

require "./t/setup_common";

test_out( 'ok 1 - readable exists' );
file_exists_ok( 'readable' );
test_out( 'ok 2 - readable really exists' );
file_exists_ok( 'readable', 'readable really exists' );
test_test();

test_out( 'not ok 1 - fooey exists' );
test_diag( 'File [fooey] does not exist');
test_diag( "  Failed test 'fooey exists'");
test_diag( "  at " . __FILE__ . " line " . (__LINE__+1) . ".");
file_exists_ok( 'fooey' );
test_test();

test_out( 'ok 1 - fooey does not exist' );
file_not_exists_ok( 'fooey' );
test_out( 'ok 2 - fooey really does not exist' );
file_not_exists_ok( 'fooey', 'fooey really does not exist' );
test_test();

test_out( 'not ok 1 - readable does not exist' );
test_diag( 'File [readable] exists');
test_diag( "  Failed test 'readable does not exist'");
test_diag( "  at " . __FILE__ . " line " . (__LINE__+1) . ".");
file_not_exists_ok( 'readable' );
test_test();

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
test_out( 'ok 1 - readable is readable' );
file_readable_ok( 'readable' );
test_out( 'ok 2 - readable really is readable' );
file_readable_ok( 'readable', 'readable really is readable' );
test_test();
SKIP: {
skip "Superuser has special privileges", 2, if( $> == 0 or $< == 0 );
test_out( 'not ok 1 - writeable is readable' );
test_diag("File [writeable] is not readable!");
test_diag("  Failed test 'writeable is readable'");
test_diag( "  at " . __FILE__ . " line " . (__LINE__+1) . ".");
file_readable_ok( 'writeable' );
test_test();
};

SKIP: {
skip "Superuser has special privileges", 3, if( $> == 0 or $< == 0 );
test_out( 'ok 1 - writeable is not readable' );
file_not_readable_ok( 'writeable' );
test_out( 'ok 2 - writeable really is not readable' );
file_not_readable_ok( 'writeable', 'writeable really is not readable' );
test_out( 'not ok 3 - readable is not readable' );
test_diag('File [readable] is readable!');
test_diag("  Failed test 'readable is not readable'");
test_diag( "  at " . __FILE__ . " line " . (__LINE__+1) . ".");
file_not_readable_ok( 'readable' );
test_test();
};

test_out( 'ok 1 - writeable is writeable' );
file_writeable_ok( 'writeable' );
test_out( 'ok 2 - writeable really is writeable' );
file_writeable_ok( 'writeable', 'writeable really is writeable' );
if( $> == 0 or $< == 0 )
{
	test_out( 'ok 3 - readable is writeable' );
}
else
{
	test_out( 'not ok 3 - readable is writeable' );
	test_diag('File [readable] is not writeable!');
	test_diag("  Failed test 'readable is writeable'");
	test_diag( "  at " . __FILE__ . " line " . (__LINE__+2) . ".");
}
file_writeable_ok( 'readable' );
test_test();

SKIP: {
skip "Superuser has special privileges", 1, if( $> == 0 or $< == 0 );
test_out( 'ok 1 - readable is not writeable' );
file_not_writeable_ok( 'readable' );
test_out( 'ok 2 - readable really is not writeable' );
file_not_writeable_ok( 'readable', 'readable really is not writeable' );
test_out( 'not ok 3 - writeable is not writeable' );
test_diag('File [writeable] is writeable!');
test_diag("  Failed test 'writeable is not writeable'");
test_diag( "  at " . __FILE__ . " line " . (__LINE__+1) . ".");
file_not_writeable_ok( 'writeable' );
test_test();
};


{
if (Test::File::_win32())
  {
	test_out("ok 1 # skip file_not_executable_ok doesn't work on Windows!");
	test_out("ok 2 # skip file_not_executable_ok doesn't work on Windows!");
	test_out("ok 3 # skip file_not_executable_ok doesn't work on Windows!");
  }
else
  {
	test_out("ok 1 - executable is executable");
	test_out("ok 2 - executable really is executable");
	test_out("not ok 3 - not_executable is executable");
	test_diag("File [not_executable] is not executable!");
	test_diag("  Failed test 'not_executable is executable'");
	test_diag("  at " . __FILE__ . " line " . (__LINE__+4) . ".");
  }
file_executable_ok( 'executable' );
file_executable_ok( 'executable', 'executable really is executable' );
file_executable_ok( 'not_executable' );
test_test();
}

{
if (Test::File::_win32())
  {
	test_out("ok 1 # skip file_not_executable_ok doesn't work on Windows!");
	test_out("ok 2 # skip file_not_executable_ok doesn't work on Windows!");
	test_out("ok 3 # skip file_not_executable_ok doesn't work on Windows!");
  }
else
  {
	test_out("ok 1 - not_executable is not executable");
	test_out("ok 2 - not_executable really is not executable");
	test_out("not ok 3 - executable is not executable");
	test_diag("File [executable] is executable!");
	test_diag("  Failed test 'executable is not executable'");
	test_diag("  at " . __FILE__ . " line " . (__LINE__+4) . ".");
  }
file_not_executable_ok( 'not_executable' );
file_not_executable_ok( 'not_executable', 'not_executable really is not executable' );
file_not_executable_ok( 'executable' );
test_test();
}

{
if (Test::File::_win32())
  {
	test_out("ok 1 # skip file_mode_is doesn't work on Windows!");
	test_out("ok 2 # skip file_mode_is doesn't work on Windows!");
	test_out("ok 3 # skip file_mode_is doesn't work on Windows!");
  }
else
  {
	test_out("ok 1 - executable mode is 0100");
	test_out("ok 2 - executable mode really is 0100");
	test_out("not ok 3 - executable mode is 0200");
	test_diag("File [executable] mode is not 0200!");
	test_diag("  Failed test 'executable mode is 0200'");
	test_diag("  at " . __FILE__ . " line " . (__LINE__+4) . ".");
  }
file_mode_is( 'executable', 0100 );
file_mode_is( 'executable', 0100, 'executable mode really is 0100' );
file_mode_is( 'executable', 0200 );
test_test();
}

{
if (Test::File::_win32())
  {
	test_out("ok 1 # skip file_mode_has doesn't work on Windows!");
	test_out("ok 2 # skip file_mode_has doesn't work on Windows!");
	test_out("ok 3 # skip file_mode_has doesn't work on Windows!");
	test_out("ok 4 # skip file_mode_has doesn't work on Windows!" );
  }
else
  {
	test_out("ok 1 - executable mode has all bits of 0100");
	test_out("ok 2 - executable mode really has all bits of 0100");
	test_out("not ok 3 - executable mode has all bits of 0200");
	test_diag("File [executable] mode is missing component 0200!");
	test_diag("  Failed test 'executable mode has all bits of 0200'");
	test_diag("  at " . __FILE__ . " line " . (__LINE__+8) . ".");
	test_out( "not ok 4 - executable mode has all bits of 0111" );
	test_diag("File [executable] mode is missing component 0011!");
	test_diag("  Failed test 'executable mode has all bits of 0111'");
	test_diag("  at " . __FILE__ . " line " . (__LINE__+5) . ".");
  }
file_mode_has( 'executable', 0100 );
file_mode_has( 'executable', 0100, 'executable mode really has all bits of 0100');
file_mode_has( 'executable', 0200 );
file_mode_has( 'executable', 0111 );
test_test();
}

{
if (Test::File::_win32)
  {
    test_out( "ok 1 # skip file_mode_isnt doesn't work on Windows!" );
    test_out( "ok 2 # skip file_mode_isnt doesn't work on Windows!" );
    test_out( "ok 3 # skip file_mode_isnt doesn't work on Windows!" );
  }
else
  {
    test_out( "ok 1 - executable mode is not 0200" );
    test_out( "ok 2 - executable mode really is not 0200" );
    test_out( "not ok 3 - executable mode is not 0100" );
    test_diag("File [executable] mode is 0100!");
    test_diag("  Failed test 'executable mode is not 0100'");
    test_diag("  at " . __FILE__ . " line " . (__LINE__+4) . ".");
  }
file_mode_isnt( 'executable', 0200 );
file_mode_isnt( 'executable', 0200, 'executable mode really is not 0200' );
file_mode_isnt( 'executable', 0100 );
test_test();
}

{
if (Test::File::_win32())
  {
    test_out( "ok 1 # skip file_mode_hasnt doesn't work on Windows!" );
    test_out( "ok 2 # skip file_mode_hasnt doesn't work on Windows!" );
    test_out( "ok 3 # skip file_mode_hasnt doesn't work on Windows!" );
  }
else
  {
    test_out( "ok 1 - executable mode has no bits of 0200" );
    test_out( "ok 2 - executable mode really has no bits of 0200" );
    test_out( "not ok 3 - executable mode has no bits of 0111" );
    test_diag("File [executable] mode has forbidden component 0100!");
    test_diag("  Failed test 'executable mode has no bits of 0111'");
    test_diag("  at " . __FILE__ . " line " . (__LINE__+4) . ".");
  }
file_mode_hasnt( 'executable', 0200 );
file_mode_hasnt( 'executable', 0200, 'executable mode really has no bits of 0200' );
file_mode_hasnt( 'executable', 0111 );
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

done_testing();
