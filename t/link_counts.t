use strict;

use Test::Builder::Tester;
use Test::More tests => 14; # includes those in t/setup_common
use Test::File;

my $test_directory = 'test_files';
SKIP: {
    skip "setup already done", 6 if -d $test_directory;
    require "t/setup_common";
};

chdir $test_directory or print "bail out! Could not change directories: $!";

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Subroutines are defined
{
my @subs = qw( link_count_is_ok link_count_gt_ok link_count_lt_ok );

foreach my $sub ( @subs )
	{
	no strict 'refs';
	ok( defined &{$sub}, "$sub is defined" );
	}

}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Stuff that should work (single link)
my $test_name     = "This is my test name";
my $readable      = 'readable';
my $readable_sym  = 'readable_sym';
my $not_there     = 'not_there';
my $dangle_sym    = 'dangle_sym';

test_out( "ok 1 - $test_name\nok 2 - $test_name\nok 3 - $test_name" );
link_count_lt_ok( $readable, 100, $test_name );
link_count_gt_ok( $readable,   0, $test_name );
link_count_is_ok( $readable,   1, $test_name );
test_test();

test_out( "ok 1 - $readable has a link count of [1]" );
link_count_is_ok( $readable, 1 );
test_test();



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Stuff that should work (multipe links)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Stuff that should fail (missing file)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Stuff that should fail (bad count)
test_out( "not ok 1 - $test_name" );
test_diag( 
	"File [$readable] points has [1] links: expected [100]!\n" .
	"#   Failed test '$test_name'\n" . 
	"#   at $0 line " . line_num(+5) . "." 
	);
link_count_is_ok( $readable, 100, $test_name );
test_test();

test_out( "not ok 1 - $test_name" );
test_diag( 
	"File [$readable] points has [1] links: expected less than [0]!\n" .
	"#   Failed test '$test_name'\n" . 
	"#   at $0 line " . line_num(+5) . "." 
	);
link_count_lt_ok( $readable, 0, $test_name );
test_test();

test_out( "not ok 1 - $test_name" );
test_diag( 
	"File [readable] points has [1] links: expected more than [100]!\n" .
	"#   Failed test '$test_name'\n" . 
	"#   at $0 line " . line_num(+5) . "." 
	);
link_count_gt_ok( $readable, 100, $test_name );
test_test();

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

chdir '..' or print "bail out! Could not change directories: $!";

END {
unlink glob( "test_files/*" );
rmdir "test_files";
}
