use strict;
use warnings;

use Test::Builder::Tester;
use Test::More tests => 8;

use_ok( 'Test::File' );

ok( defined &{ "Test::File::_win32" }, "_win32 defined" );

{
local $^O = 'darwin';
ok( ! Test::File::_win32(), "Returns false for darwin" );
}

{
local $^O = 'Win32';
ok( Test::File::_win32(), "Returns true for Win32" );
}

{
local $^O = 'Win32';

my @subs = qw(
	file_mode_is file_mode_isnt
	file_executable_ok file_not_executable_ok
	);

foreach my $sub ( @subs )
	{
	no strict 'refs';

	test_out("ok 1 # skip $sub doesn't work on Windows!");
	&{$sub}();
	test_test();
	}

}
