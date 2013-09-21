package Error::Pure;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Utils qw();
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err);
Readonly::Scalar my $TYPE_DEFAULT => 'Die';
Readonly::Scalar my $LEVEL_DEFAULT => 4;

# Version.
our $VERSION = 0.13;

# Type of error.
our $TYPE = $TYPE_DEFAULT;

# Level for this class.
our $LEVEL = $LEVEL_DEFAULT;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

# Process error.
sub err {
	my @msg = @_;
	$Error::Pure::Utils::LEVEL = $LEVEL;
	my $class;
	if ($TYPE && $TYPE ne $TYPE_DEFAULT) {
		$class = 'Error::Pure::'.$TYPE;
	} elsif ($ENV{'ERROR_PURE_TYPE'}) {
		$class = 'Error::Pure::'.
			$ENV{'ERROR_PURE_TYPE'};
	} else {
		$class = 'Error::Pure::'.$TYPE_DEFAULT;
	}
	eval "require $class";
	if ($EVAL_ERROR) {
		my $err = $EVAL_ERROR;
		$err =~ s/\ at.*$//ms;
		die $err;
	}
	eval $class.'::err @msg';
	if ($EVAL_ERROR) {
		die $EVAL_ERROR;
	}
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure - Perl module for structured errors.

=head1 SYNOPSIS

 use Error::Pure qw(err);
 err 'This is a fatal error', 'name', 'value';

=head1 SUBROUTINES

=over 8

=item B<err(@messages)>

 Process error with messages @messages.

=back

=head1 VARIABLES

=over 8

=item B<$LEVEL>

 Error level for Error::Pure.
 Default value is 4.

=item B<$TYPE>

 Available are last names in Error::Pure::* modules.
 Error::Pure::ErrorList means 'ErrorList'.
 If does defined ENV variable 'ERROR_PURE_TYPE', system use it.
 Default value is 'Die'.

 Precedence:
 1) $Error::Pure::TYPE
 2) $ENV{'ERROR_PURE_TYPE'}
 3) $Error::Pure::TYPE_DEFAULT = 'Die'

=back

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure qw(err);

 # Error.
 err '1';

 # Output:
 # 1 at example1.pl line 9.

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure qw(err);

 # Set env error type.
 $ENV{'ERROR_PURE_TYPE'} = 'ErrorList';

 # Error.
 err '1';

 # Output something like:
 # #Error [path_to_script:12] 1

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure qw(err);

 # Set error type.
 $Error::Pure::TYPE = 'AllError';

 # Error.
 err '1';

 # Output something like:
 # ERROR: 1
 # main  err  path_to_script  12

=head1 EXAMPLE4

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure qw(err);

 $SIG{__DIE__} = sub {
         my $err = shift;
         $err =~ s/ at .*\n//ms;
         $Error::Pure::LEVEL = 5;
         $Error::Pure::TYPE = 'ErrorList';
         err $err;
 };

 # Error.
 die 'Error';

 # Output.
 # #Error [path_to_script.pl:17] Error

=head1 DEPENDENCIES

L<English>,
L<Error::Pure::Utils>,
L<Exporter>,
L<Readonly>.

=head1 SEE ALSO

L<Error::Pure>,
L<Error::Pure::AllError>,
L<Error::Pure::Always>,
L<Error::Pure::Die>,
L<Error::Pure::Error>,
L<Error::Pure::ErrorList>,
L<Error::Pure::HTTP::AllError>,
L<Error::Pure::HTTP::Error>,
L<Error::Pure::HTTP::ErrorList>,
L<Error::Pure::HTTP::JSON>,
L<Error::Pure::HTTP::Print>,
L<Error::Pure::JSON>,
L<Error::Pure::Output::JSON>,
L<Error::Pure::Output::Text>,
L<Error::Pure::Print>.

=head1 ACKNOWLEDGMENTS

Jakub Špičak and his Masser (L<http://masser.sf.net>).

=head1 REPOSITORY

L<https://github.com/tupinek/Error-Pure>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.13

=cut
