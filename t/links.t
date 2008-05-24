# $Id$
use strict;

use Test::Builder::Tester;
use Test::More tests => 5;
use Test::File;

=pod

max_file       non_zero_file  not_readable   readable       zero_file
executable     min_file       not_executable not_writeable  writeable

=cut

my $can_symlink = eval { symlink("",""); 1 };

my $test_directory = 'test_files';
SKIP: {
    skip "This system does't do symlinks", 5 unless $can_symlink;
    require "t/setup_common";
};

END {
unlink glob( "test_files/*" );
rmdir "test_files";
}