# $Id$
use ExtUtils::MakeMaker;

my $tests = do {
	local @ARGV = qw(t/test_manifest);
	my $data = join " ", map {chomp; "t/$_" } <>;
	};

WriteMakefile
        (
        'NAME'      => 'Test::File',
        'ABSTRACT'  => 'Check file attributes',
        'VERSION'   => '0.05',
 		'PREREQ_PM' => {
 			'File::Find::Rule'      => 0,
 			'Test::Pod'             => 0,
 			'Test::More'            => 0,
 			'Test::Builder::Tester' => 0,
 			'Test::Builder'         => 0,
 			'Test::Prereq'          => 0,
 			},
        'PM'        => 
        	{
            'lib/File.pm'     => '$(INST_LIBDIR)/File.pm',
          },
 
		test   => { TESTS      => $tests },
		depend => { 'Makefile' => 't/test_manifest' },
        );

