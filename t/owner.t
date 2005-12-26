# $Id$
use strict;

use Test::Builder::Tester;
use Test::More;
use Test::File;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#let's test with the first file we find in the current dir
my( $filename, $owner_uid, $owner_name );
eval 	
	{
	$filename = glob( "*" );
	#print STDERR "Filename is $filename\n";
	
	die "Could not find a file" unless defined $filename;

	$owner_uid = ( stat $filename )[4];
	die "failed to find $filename's owner\n" unless defined $owner_uid;
		
	$owner_name = ( getpwuid $owner_uid )[0];
	die "failed to find $filename's owner's uid\n" unless defined $owner_name;
	};
plan skip_all => "I can't find a file to test with: $@" if $@;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# find some name that isn't the one we found before
my( $other_name, $other_uid );
eval 
	{
	for( my $i = 0; $i < 65535; $i++ )	
		{
		next if $i == $owner_uid;	

		my @stats = getpwuid $i;
		next unless @stats;

		( $other_uid, $other_name )  = ( $i, $stats[0] );

		last;
		}
		
	die "Failed to find another uid" unless defined $other_uid;
	die "Failed to find name for other uid ($other_uid)" 
		unless defined $other_name;
	};
plan skip_all => "I can't find a second user id to test with: $@" if $@;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
plan tests => 6;

owner_is(   $filename, $owner_name, 'owner_is with text username'   );
owner_is(   $filename, $owner_uid,  'owner_is with numeric UID'     );
owner_isnt( $filename, $other_name, 'owner_isnt with text username' );
owner_isnt( $filename, $other_uid,  'owner_isnt with numeric UID'   );

my $name = 'Intentional owner_is failure';
test_out( "not ok 1 - $name");
test_diag( 
	"File [$filename] belongs to $owner_name ($owner_uid), not $other_name " .
	"($other_uid)\n" .
	"#   Failed test '$name'\n". 
	"#   in t/owner.t at line " . line_num(+6) . "." 
	);
owner_is( $filename, $other_name, $name );
test_test( $name );

$name = 'Intentional owner_isnt failure';

test_out( "not ok 1 - $name");
test_diag( 
	"File [$filename] belongs to $owner_name ($owner_uid)\n" .
	"#   Failed test '$name'\n" . 
	"#   in t/owner.t at line " . line_num(+5) . "."
	);
owner_isnt( $filename, $owner_name, "Intentional owner_isnt failure" );
test_test( "Intentional owner_isnt failure");