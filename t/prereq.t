#$Id$
use Test::More;
eval "use Test::Prereq 1.0";
plan skip_all => "Test::Prereq required to test dependencies" if $@;
prereq_ok( undef, undef, [ qw(t/setup_common) ] );
