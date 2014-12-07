package Error::Pure::PrintVar;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(err_helper);
use Error::Pure::Output::Text qw(err_print_var);
use List::MoreUtils qw(none);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err);
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $EVAL => 'eval {...}';

# Version.
our $VERSION = 0.21;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

# Process error.
sub err {
	my @msg = @_;

	# Get errors structure.
	my @errors = err_helper(@msg);

	# Finalize in main on last err.
	my $stack_ar = $errors[-1]->{'stack'};
	if ($stack_ar->[-1]->{'class'} eq 'main'
		&& none { $_ eq $EVAL || $_ =~ /^eval '/ms }
		map { $_->{'sub'} } @{$stack_ar}) {

		die scalar err_print_var(@errors);

	# Die for eval.
	} else {
		die "$errors[-1]->{'msg'}->[0]\n";
	}

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure::PrintVar - Error::Pure module for simple error print with all variables.

=head1 SYNOPSIS

 use Error::Pure::PrintVar qw(err);
 err 'This is a fatal error', 'name', 'value';

=head1 SUBROUTINES

=over 8

=item C<err(@messages)>

 Process error with messages @messages.

=back

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::PrintVar qw(err);

 # Error.
 err '1';

 # Output:
 # 1

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::PrintVar qw(err);

 # Error.
 err '1', '2', '3';

 # Output:
 # 1
 # 2: 3

=head1 EXAMPLE3

 package Example3;

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::PrintVar qw(err);

 # Test with error.
 sub test {
         err '1', '2', '3';
 }

 package main;

 # Pragmas.
 use strict;
 use warnings;

 # Run.
 Example3::test();

 # Output:
 # Example3: 1
 # 2: 3

=head1 DEPENDENCIES

L<Error::Pure::Utils>,
L<Error::Pure::Output::Text>,
L<Exporter>,
L<List::MoreUtils>,
L<Readonly>.

=head1 SEE ALSO

L<Error::Pure>,
L<Error::Pure::AllError>,
L<Error::Pure::Die>,
L<Error::Pure::Error>,
L<Error::Pure::ErrorList>,
L<Error::Pure::HTTP::AllError>,
L<Error::Pure::HTTP::Error>,
L<Error::Pure::HTTP::ErrorList>,
L<Error::Pure::HTTP::Print>,
L<Error::Pure::Output::Text>,
L<Error::Pure::Print>,
L<Error::Pure::Utils>.

=head1 REPOSITORY

L<https://github.com/tupinek/Error-Pure>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

 © Michal Špaček 2008-2014
 BSD 2-Clause License

=head1 VERSION

0.21

=cut
