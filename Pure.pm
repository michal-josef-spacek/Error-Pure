#------------------------------------------------------------------------------
package Error::Pure;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(clean err err_get err_helper);
Readonly::Scalar my $EMPTY => q{};
Readonly::Scalar my $EVAL => 'eval {...}';
Readonly::Scalar my $DOTS => '...';

# Version.
our $VERSION = 0.01;

# Errors array.
our @ERRORS;

# Default initialization.
our $level = 2;
our $max_levels = 50;
our $max_eval = 100;
our $max_args = 10;
our $max_arg_len = 50;
our $program = $EMPTY;       # Program name in stack information.

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

#------------------------------------------------------------------------------
sub clean {
#------------------------------------------------------------------------------
# Clean internal structure.

	@ERRORS = ();
	return;
}

#------------------------------------------------------------------------------
sub err {
#------------------------------------------------------------------------------
# Process error.

	my @args = @_;
	my $msg_ar = \@args;
	my $ERRORS = err_helper($msg_ar);
	my $tmp = $ERRORS->[-1]->{'stack'}->[0];
	CORE::die $msg_ar->[0]." at $tmp->{'prog'} line $tmp->{'line'}.\n";
	return;
}

#------------------------------------------------------------------------------
sub err_get {
#------------------------------------------------------------------------------
# Get and clean processed errors.

	my $clean = shift;
	my @ret = @ERRORS;
	if ($clean) {
		clean();
	}
	return wantarray ? @ret : \@ret;
}

#------------------------------------------------------------------------------
sub err_helper {
#------------------------------------------------------------------------------
# Process error without die.

	my $msg_ar = shift;
	my $stack = [];

	# Get calling stack.
	$stack = _get_stack();

	# Create errors message.
	push @ERRORS, {
		'msg' => $msg_ar,
		'stack' => $stack,
	};

	return \@ERRORS;
}

#------------------------------------------------------------------------------
# Private functions.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _get_stack {
#------------------------------------------------------------------------------
# Get information about place of error.

	my $max_level = shift || $max_levels;
	my @stack;
	my $tmp_level = $level;
	my ($class, $prog, $line, $sub, $hargs, $evaltext, $is_require);
	while ($tmp_level < $max_level
		&& do { package DB; ($class, $prog, $line, $sub, $hargs,
		undef, $evaltext, $is_require) = caller($tmp_level++); }) {

		# Sub name.
		if (defined $evaltext) {
			if ($is_require) {
				$sub = "require $evaltext";
			} else {
				$evaltext =~ s/\n;//sm;
				$evaltext =~ s/([\'])/\\$1/gsm;
				if ($max_eval
					&& length($evaltext) > $max_eval) {

					substr($evaltext, $max_eval, -1,
						$DOTS);
				}
				$sub = "eval '$evaltext'";
			}

		# My eval name.
		} elsif ($sub eq '(eval)') {
			$sub = $EVAL;

		# Other transformation.
		} else {
			$sub =~ s/^$class\:\:([^:]+)$/$1/gsmx;
			if ($sub =~ /^Error::Pure::(.*)err$/smx) {
				$sub = 'err';
			}
			if ($program && $prog =~ /^\(eval/sm) {
				$prog = $program;
			}
		}

		# Args.
		my $i_args = $EMPTY;
		if ($hargs) {
			my @args = @DB::args;
			if ($max_args && $#args > $max_args) {
				$#args = $max_args;
				$args[-1] = $DOTS;
			}

			# Get them all.
			foreach (@args) {
				$_ = 'undef', next unless defined $_;
				if (ref $_) {

					# Force string representation.
					$_ .= $EMPTY;
				}
				s/'/\\'/gsm;
				if ($max_arg_len && length > $max_arg_len) {
					substr($_, $max_arg_len, -1, $DOTS);
				}

				# Quote (not for numbers).
				if (! m/^-?[\d.]+$/sm) {
					$_ = "'$_'";
				}
			}
			$i_args = '('.join(', ', @args).')';
		}

		# Information to stack.
		$sub =~ s/\n$//sm;
		push @stack, {
			'class' => $class,
			'prog' => $prog,
			'line' => $line,
			'sub' => $sub,
			'args' => $i_args
		};
	}

	# Stack.
	return \@stack;
}

BEGIN {
	no warnings qw(redefine);
        *CORE::GLOBAL::die = \&err;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure - Perl module for structured errors.

=head1 SYNOPSIS

 use Error::Pure qw(err err_get err_helper);
 err 'This is a fatal error', 'name', 'value';
 my @ret = err_get(1);
 my $errors = err_helper(['This is a fatal error', 'name', 'value']);

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

=item B<err_helper($msg_ar)>

 Subroutine for additional classes above Error::Pure. Is exportable.
 $msg is reference to array of messages.

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
 use Error::Pure;

 # Error.
 die '1';

 # Output:
 # 1 at example1.pl line 9.

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure;

 # Error.
 die '1', '2', '3';

 # Output:
 # 1 at example2.pl line 9.

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure;

 # Error in eval.
 eval { die '1', '2', '3'; };

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

L<Error::Pure::AllError(3pm)>,
L<Error::Pure::Clean(3pm)>,
L<Error::Pure::Error(3pm)>,
L<Error::Pure::ErrorList(3pm)>,
L<Error::Pure::Output::Text(3pm)>,
L<Error::Pure::Print(3pm)>,
L<Error::Pure::Multiple(3pm)>.

=head1 AUTHOR

Michal Špaček L<tupinek@gmail.com>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
