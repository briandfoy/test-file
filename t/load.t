# $Id$
BEGIN {
	@classes = qw(Test::File);
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "Bail out! $class did not compile!" unless use_ok( $class );
	}
