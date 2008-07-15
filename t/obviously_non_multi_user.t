# $Id: normalize.t 1553 2005-01-06 23:35:53Z comdog $

use Test::More tests => 8;

BEGIN { 
	our $getpwuid_should_die = 0;
	our $getgrgid_should_die = 0;
	};

BEGIN{ 
	no warnings;
	
	*CORE::GLOBAL::getpwuid = sub ($) { die "Fred"   if $getpwuid_should_die };
	*CORE::GLOBAL::getgrgid = sub ($) { die "Barney" if $getgrgid_should_die };
	}
	
use_ok( 'Test::File' );

ok( defined &{ "Test::File::_obviously_non_multi_user" }, "_win32 defined" );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# The ones that we know aren't multi-user
{
local $^O = 'MacOS';
ok( Test::File::_obviously_non_multi_user(), "Returns false for MacOS" );
}

{
local $^O = 'dos';
ok( Test::File::_obviously_non_multi_user(), "Returns true for Win32" );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# The ones that use get*, but die
{
local $^O = 'Fooey';
$getpwuid_should_die = 1;
$getgrgid_should_die = 0;
ok( Test::File::_obviously_non_multi_user(), 'getpwuid dying returns true' );
}

{
local $^O = 'Fooey';
$getpwuid_should_die = 0;
$getgrgid_should_die = 1;
ok( Test::File::_obviously_non_multi_user(), 'getgrgid dying returns true' );
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# The ones that use get*, but don't die
{
local $^O = 'Fooey';
$getpwuid_should_die = 0;
$getgrgid_should_die = 0;
ok( ! Test::File::_obviously_non_multi_user(), 'getpwuid dying returns true' );
}

{
local $^O = 'Fooey';
$getpwuid_should_die = 0;
$getgrgid_should_die = 0;
ok( ! Test::File::_obviously_non_multi_user(), 'getgrgid dying returns true' );
}
