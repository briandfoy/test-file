package Test::File;
use strict;

use base qw(Exporter);
use vars qw(@EXPORT);

use Test::Builder;

@EXPORT = qw(
	file_exists_ok file_not_exists_ok
	file_empty_ok file_not_empty_ok file_size_ok file_max_size_ok
	file_min_size_ok file_readable_ok file_not_readable_ok file_writeable_ok
	file_not_writeable_ok file_executable_ok file_not_executable_ok
	);

my $Test = Test::Builder->new();

=head1 NAME

Test::File -- test file attributes

=head1 SYNOPSIS

use Test::File;

=head1 DESCRIPTION

This modules provides a collection of test utilities for
file attributes. 

Some file attributes depend on the owner of the process testing
the file in the same way the file test operators do.

=head2 FUNCTIONS

=over 4

=item file_exists_ok( FILENAME [, NAME ] )

Ok if the file exists, and not ok otherwise.

=cut

sub file_exists_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename exists";
	
	my $ok = -e $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] does not exist");
		$Test->ok(0, $name);
		}
	}
	
=item file_not_exists_ok( FILENAME [, NAME ] )

Ok if the file does not exist, and not okay if it does exist.

=cut

sub file_not_exists_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename does not exist";
	
	my $ok = not -e $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] exists");
		$Test->ok(0, $name);
		}
	}

=item file_empty_ok( FILENAME [, NAME ] )

Ok if the file exists and has empty size, not ok if the
file does not exist or exists with non-zero size.

=cut

sub file_empty_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is empty";
	
	my $ok = -z $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		if( -e $filename )
			{
			my $size = -s $filename;
			$Test->diag( 'File exists with non-zero size [$size] b');
			}
		else
			{
			$Test->diag( 'File does not exist');
			}
			
		$Test->ok(0, $name);
		}
	}

=item file_not_empty_ok( FILENAME [, NAME ] )

Ok if the file exists and has non-zero size, not ok if the
file does not exist or exists with zero size.

=cut

sub file_not_empty_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is not empty";
	
	my $ok = not -z $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		if( -e $filename and -z $filename )
			{
			$Test->diag( 'File [$filename] exists with zero size');
			}
		else
			{
			$Test->diag( 'File [$filename] does not exist');
			}
			
		$Test->ok(0, $name);
		}
	}

=item file_size_ok( FILENAME, SIZE [, NAME ]  )

Ok if the file exists and has SIZE size (exactly), not ok if the
file does not exist or exists with size other than SIZE.

=cut

sub file_size_ok($$;$)
	{
	my $filename = shift;
	my $expected = int shift;
	my $name     = shift || "$filename has right size";
	
	my $ok = ( -s $filename ) == $expected;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		unless( -e $filename )
			{
			$Test->diag( 'File [$filename] does not exist');
			}
		else
			{
			my $actual = -s $filename;
			$Test->diag( 'File [$filename] has actual size [$actual] not [$expected]');
			}
			
		$Test->ok(0, $name);
		}
	}

=item file_max_size_ok( FILENAME, MAX [, NAME ] )

Ok if the file exists and has size less than or equal to MAX, not ok 
if the file does not exist or exists with size greater than MAX.

=cut

sub file_max_size_ok($$;$)
	{
	my $filename = shift;
	my $max      = int shift;
	my $name     = shift || "$filename is under $max bytes";
	
	my $ok = ( -s $filename ) <= $max;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		unless( -e $filename )
			{
			$Test->diag( 'File [$filename] does not exist');
			}
		else
			{
			my $actual = -s $filename;
			$Test->diag( 'File [$filename] has actual size [$actual] greater than [$max]');
			}
			
		$Test->ok(0, $name);
		}
	}
	
=item file_min_size_ok( FILENAME, MIN [, NAME ] )

Ok if the file exists and has size greater than or equal to MIN, not ok 
if the file does not exist or exists with size less than MIN.

=cut

sub file_min_size_ok($$;$)
	{
	my $filename = shift;
	my $min      = int shift;
	my $name     = shift || "$filename is over $min bytes";
	
	my $ok = ( -s $filename ) >= $min;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		unless( -e $filename )
			{
			$Test->diag( 'File [$filename] does not exist');
			}
		else
			{
			my $actual = -s $filename;
			$Test->diag( 'File [$filename] has actual size [$actual] less than [$min]');
			}
			
		$Test->ok(0, $name);
		}
	}
	
=item file_readable_ok( FILENAME [, NAME ] )

Ok if the file exists and is readable, not ok 
if the file does not exist or is not readable.

=cut

sub file_readable_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is readable";
	
	my $ok = -r $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] is not readable");
		$Test->ok(0, $name);
		}
	}

=item file_not_readable_ok( FILENAME [, NAME ] )

Ok if the file exists and is not readable, not ok 
if the file does not exist or is readable.

=cut

sub file_not_readable_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is not readable";
	
	my $ok = not -r $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] is readable");
		$Test->ok(0, $name);
		}
	}

=item file_writeable_ok( FILENAME [, NAME ] )

Ok if the file exists and is writeable, not ok 
if the file does not exist or is not writeable.

=cut

sub file_writeable_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is writeable";
	
	my $ok = -w $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] is not writeable");
		$Test->ok(0, $name);
		}
	}

=item file_not_writeable_ok( FILENAME [, NAME ] )

Ok if the file exists and is not writeable, not ok 
if the file does not exist or is writeable.

=cut

sub file_not_writeable_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is not writeable";
	
	my $ok = not -w $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] is writeable");
		$Test->ok(0, $name);
		}
	}

=item file_executable_ok( FILENAME [, NAME ] )

Ok if the file exists and is executable, not ok 
if the file does not exist or is not executable.

=cut

sub file_executable_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is executable";
	
	my $ok = -x $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] is not executable");
		$Test->ok(0, $name);
		}
	}

=item file_not_executable_ok( FILENAME [, NAME ] )

Ok if the file exists and is not executable, not ok 
if the file does not exist or is executable.

=cut

sub file_not_executable_ok($;$)
	{
	my $filename = shift;
	my $name     = shift || "$filename is not executable";
	
	my $ok = not -x $filename;
	
	if( $ok )
		{
		$Test->ok(1, $name);
		}
	else
		{
		$Test->diag("File [$filename] is executable");
		$Test->ok(0, $name);
		}
	}

=back

=head1 TO DO

* check properties for other users (readable_by_root, for instance)

* check owner, group

* check times

* check mode

* check number of links to file

* check path parts (directory, filename, extension)

=head1 SEE ALSO

L<Test::Builder>,
L<Test::More>

=head1 AUTHOR

brian d foy, E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, brian d foy, All Rights Reserved

You may use, modify, and distribute this under the same terms
as Perl itself.

=cut

"The quick brown fox jumped over the lazy dog";
