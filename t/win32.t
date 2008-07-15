# $Id: normalize.t 1553 2005-01-06 23:35:53Z comdog $

use Test::More tests => 4;

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

foreach my $function ( )
	{
	no strict 'refs';
	
	&{$function}	
	
	}