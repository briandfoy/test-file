use ExtUtils::MakeMaker 6.48;

require 5.006;

eval "use Test::Manifest 1.21";

WriteMakefile(
	'NAME'          => 'Test::File',
	'ABSTRACT'      => 'Check file attributes',
	'LICENSE'		=> 'perl',
	'AUTHOR'		=> 'brian d foy <bdfoy@cpan.org>',

	'VERSION_FROM'   => 'lib/Test/File.pm',

	'PREREQ_PM' => {
		'Test::More'            => '0.95',
		'Test::Builder::Tester' => '1.04',
		'Test::Builder'         => '1.001006',
		},

	META_ADD => {
		no_index => {
			package   => [ qw( version Local ) ],
			directory => [ qw( t/inc inc ) ],
			file      => [ qw( t/lib/test.pm ) ],
			namespace => [ qw( Local ) ],
			},
		},

	META_MERGE       => {
		'meta-spec' => { version => 2 },
		keywords    => ['testing','file'],
		resources   => {
		  		repository => {
		  			type => 'git',
		  			url  => 'git://github.com/briandfoy/test-file.git',
		  			web  => 'https://github.com/briandfoy/test-file',
		  			},
				},
		},

	clean  => { FILES    => q|Test-File-* test_files| },
	);

