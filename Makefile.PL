# $Id$
use ExtUtils::MakeMaker;

eval "use Test::Manifest";
unless( $@ )
   {
   * ExtUtils::MM_Any::test_via_harness = sub
	   {
	   my($self, $perl, $tests) = @_;

	   return qq|\t$perl "-MTest::Manifest" | .
				  qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
				  qq|'\$(INST_ARCHLIB)')"\n|;
	   }
   }

WriteMakefile
        (
        'NAME'           => 'Test::File',
        'ABSTRACT'       => 'Check file attributes',
        'VERSION_FROM'   => 'lib/File.pm',

 		'PREREQ_PM' => {
 			'Test::More'            => '0',
 			'Test::Builder::Tester' => '0',
 			'Test::Builder'         => '0',
 			},

		'PM'        => {
            'lib/File.pm'     => '$(INST_LIBDIR)/File.pm',
          },
 
		'MAN3PODS'     => {
			'lib/file.pm' => '$(INST_MAN3DIR)/Test::File.3',
			},
	
		clean  => { FILES    => q|Test::File-* test_files| },
        );

