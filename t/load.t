# $Id$
BEGIN {
	use File::Find::Rule;
	@classes = map { my $x = $_;
			$x =~ s|^blib/lib/||;
			$x =~ s|/|::|g;
			$x =~ s|\.pm$||;
			$x;
			} File::Find::Rule->file()->name( '*.pm' )->in( 'blib/lib' );
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! $class did not compile!" unless use_ok( $class );
	}
