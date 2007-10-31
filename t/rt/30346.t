# $Id: owner.t 1950 2006-11-24 22:28:56Z comdog $
use strict;

use Test::Builder::Tester;
use Test::More tests => 3;

use Test::File;

use Cwd;

# File does not exist
{
my $file = "no_such_file-" . "$$" . time() . "b$<$>m";

unlink $file;

my $name = "$file is not empty";
test_out( "not ok 1 - $name");
test_diag( 
	"File [$file] does not exist\n" .
	"#   Failed test '$name'\n". 
	"#   at $0 line " . line_num(+5) . "." 
	);
file_not_empty_ok( $file );
test_test( $name );
}



# File exists, non zero size
{
my $file = $0; # hey, that's me!

my $name = "$file is not empty";
test_out( "ok 1 - $name");
file_not_empty_ok( $file );
test_test( $name );
}



# File exists, zero size
{
require File::Spec;
my $file = File::Spec->catfile( qw(t rt file_not_empty_ok_test) );
open my $fh, ">", $file;
truncate $fh, 0;
close $fh;

my $name = "$file is not empty";
test_out( "not ok 1 - $name");
test_diag( 
	"File [$file] exists with zero size\n" .
	"#   Failed test '$name'\n". 
	"#   at $0 line " . line_num(+5) . "." 
	);
file_not_empty_ok( $file );
test_test( $name );

unlink $file;
}
