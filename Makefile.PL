# $Id$
use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.21";

WriteMakefile
	(
	'NAME'          => 'Test::File',
	'ABSTRACT'      => 'Check file attributes',
	'LICENSE'		=> 'perl',
	'AUTHOR'		=> 'brian d foy <bdfoy@cpan.org>',

	'VERSION_FROM'   => 'lib/File.pm',

	'PREREQ_PM' => {
		'Test::More'            => '0.65',
		'Test::Builder::Tester' => '1.04',
		'Test::Builder'         => '0.33',
		'Test::Manifest'        => '1.14',
		},

	'PM'        => {
		'lib/File.pm'     => '$(INST_LIBDIR)/File.pm',
		},

	'MAN3PODS'  => {
		'lib/File.pm'     => '$(INST_MAN3DIR)/File.$(MAN3EXT)',
		},

	clean  => { FILES    => q|Test-File-* test_files| },
	);

