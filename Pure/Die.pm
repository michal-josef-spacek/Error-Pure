package Error::Pure::Die;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(err_helper);
use List::MoreUtils qw(none);
use Readonly;

# Version.
our $VERSION = 0.01;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err);
Readonly::Scalar my $EVAL => 'eval {...}';

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

# Process error.
sub err {
	my @msg = @_;

	# Get errors structure.
	my $errors_ar = err_helper(@msg);

	# Error message.
	my $e = $errors_ar->[-1]->{'msg'}->[0];
	chomp $e;

	my $stack_ar = $errors_ar->[-1]->{'stack'};
	if ($stack_ar->[-1]->{'class'} eq 'main'
		&& none { $_ eq $EVAL || $_ =~ /^eval '/ms }
		map { $_->{'sub'} } @{$stack_ar}) {

		die "$e at $stack_ar->[0]->{'prog'} line ".
			"$stack_ar->[0]->{'line'}.\n";

	# Die for eval.
	} else {
		die "$e\n";
	}
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure::Die - Perl module for structured errors.

=head1 SYNOPSIS

 use Error::Pure::Die qw(err err_get err_helper);
 err 'This is a fatal error', 'name', 'value';
 my @ret = err_get(1);
 my $errors_ar = err_helper('This is a fatal error', 'name', 'value');

=head1 SUBROUTINES

=over 8

=item B<clean()>

 Resets internal variables with errors.

=item B<err(@messages)>

 Process error with messages @messages.

=item B<err_get([$clean])>

 Get and clean processed errors.
 err_get() returns error structure.
 err_get(1) returns error structure and delete it internally.
 In array mode returns array of errors.
 In scalar mode return reference to array of errors.
 Exportable as default.

=item B<err_helper(@msg)>

 Subroutine for additional classes above Error::Pure. Is exportable.
 @msg is array of messages.

=back

=head1 VARIABLES

=over 8

=item B<$LEVEL>

Default value is 2.

=item B<$MAX_LEVELS>

Default value is 50.

=item B<$MAX_EVAL>

Default value is 100.

=item B<$MAX_ARGS>

Default value is 10.

=item B<$MAX_ARG_LEN>

Default value is 50.

=item B<$PROGRAM>

 Program name in stack information.
 Default value is ''.

=back

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Die qw(err);

 # Error.
 err '1';

 # Output:
 # 1 at example1.pl line 9.

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Die qw(err);

 # Error.
 err '1', '2', '3';

 # Output:
 # 1 at example2.pl line 9.

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Die qw(err);

 # Error in eval.
 eval { err '1', '2', '3'; };

 # Error structure.
 my $err_struct = err_get();

 # In $err_struct:
 # [
 #         {
 #                 'msg' => [
 #                         '1',
 #                         '2',
 #                         '3',
 #                 ],
 #                 'stack' => [
 #                         {
 #                                 'args' => '(1)',
 #                                 'class' => 'main',
 #                                 'line' => '9',
 #                                 'prog' => 'ex2.pl',
 #                                 'sub' => 'err',
 #                         },
 #                         {
 #                                 'args' => '',
 #                                 'class' => 'main',
 #                                 'line' => '9',
 #                                 'prog' => 'ex2.pl',
 #                                 'sub' => 'eval {...}',
 #                         },
 #                 ],
 #         },
 # ],

=head1 DEPENDENCIES

L<Cwd(3pm)>,
L<Exporter(3pm)>,
L<List::MoreUtils(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Error::Pure(3pm)>,
L<Error::Pure::AllError(3pm)>,
L<Error::Pure::Clean(3pm)>,
L<Error::Pure::Error(3pm)>,
L<Error::Pure::ErrorList(3pm)>,
L<Error::Pure::Output::Text(3pm)>,
L<Error::Pure::Print(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
