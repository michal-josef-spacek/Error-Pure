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
Readonly::Scalar my $TYPE_DEFAULT => 'Print';
Readonly::Scalar my $LEVEL_DEFAULT => 4;

# Version.
our $VERSION = 0.01;

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
	my $class = $TYPE ? 'Error::Pure::'.$TYPE : 'Error::Pure::Die';
	eval "require $class";
	eval $class.'::err @msg';
	if ($EVAL_ERROR) {
		CORE::die $EVAL_ERROR;
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

 use Error::Simple qw(err);
 err 'This is a fatal error', 'name', 'value';

=head1 SUBROUTINES

=over 8

=item B<err(@messages)>

 Process error with messages @messages.

=back

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Simple;

 # Error.
 err '1';

 # Output:
 # 1 at example1.pl line 9.

=head1 DEPENDENCIES

L<English(3pm)>,
L<Error::Pure::Utils(3pm)>,
L<Exporter(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Error::Pure(3pm)>,
L<Error::Pure::AllError(3pm)>,
L<Error::Pure::Clean(3pm)>,
L<Error::Pure::Die(3pm)>,
L<Error::Pure::Error(3pm)>,
L<Error::Pure::ErrorList(3pm)>,
L<Error::Pure::Output::Text(3pm)>,
L<Error::Pure::Print(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
