require 5.008;
use strict;
use warnings;

my $github    = 'https://github.com/briandfoy/test-file';
my $main_file = 'lib/Test/File.pm';

my %WriteMakefile = (
	'NAME'          => 'Test::File',
	'VERSION_FROM'  => $main_file,
	'ABSTRACT_FROM' => $main_file,
	'LICENSE'		=> 'perl',
	'AUTHOR'		=> 'brian d foy <bdfoy@cpan.org>',
	
	'CONFIGURE_REQUIRES' => {
		'ExtUtils::MakeMaker' => '6.64',
		},

	'BUILD_REQUIRES' => {
		},

	'TEST_REQUIRES' => {
		'Test::More' => '0.94',
		},

	'PREREQ_PM' => {
		'Test::More'            => '0.95',
		'Test::Builder::Tester' => '1.04',
		'Test::Builder'         => '1.001006',
		'Test::utf8'            => '0',
		},

	'META_MERGE' => {
		'meta-spec' => { version => 2 },
		keywords    => ['testing','file'],
		resources => {
			repository => {
				type => 'git',
				url  => "$github.git",
				web  => $github,
				},
			bugtraker => {
				web    => "$github/issues",
				},
			homepage => $github,
			},
		no_index => {
			package   => [ qw( version Local ) ],
			directory => [ qw( t/inc inc ) ],
			file      => [ qw( t/lib/test.pm ) ],
			namespace => [ qw( Local ) ],
			},
		},

	clean  => { FILES    => q|Test-File-* test_files| },
	);


sub arguments { \%WriteMakefile }

do_it() unless caller;
sub do_it {
	my $MM ='ExtUtils::MakeMaker';
	my $MM_version =
		eval{ "$MM " . $WriteMakefile{'CONFIGURE_REQUIRES'}{'ExtUtils::MakeMaker'} }
			//
		"$MM 6.64";
	eval "use $MM_version" || die "Could not load $MM_version: $@";
	eval "use Test::Manifest 1.21";
	WriteMakefile( %WriteMakefile );
	}


no warnings;
__PACKAGE__;
