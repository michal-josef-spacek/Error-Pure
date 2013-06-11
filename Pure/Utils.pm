package Error::Pure::Utils;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Cwd qw(abs_path);
use Readonly;

# Version.
our $VERSION = 0.10;

# Constants.
Readonly::Array our @EXPORT_OK => qw(clean err_get err_helper);
Readonly::Scalar my $DOTS => '...';
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $EVAL => 'eval {...}';
Readonly::Scalar my $UNDEF => 'undef';

# Errors array.
our @ERRORS;

# Default initialization.
our $LEVEL = 2;
our $MAX_LEVELS = 50;
our $MAX_EVAL = 100;
our $MAX_ARGS = 10;
our $MAX_ARG_LEN = 50;
our $PROGRAM = $EMPTY_STR;       # Program name in stack information.

# Clean internal structure.
sub clean {
	@ERRORS = ();
	return;
}

# Get and clean processed errors.
sub err_get {
	my $clean = shift;
	my @ret = @ERRORS;
	if ($clean) {
		clean();
	}
	return @ret;
}

# Process error without die.
sub err_helper {
	my @msg = @_;

	# Check to undefined values in @msg.
	for (my $i = 0; $i < @msg; $i++) {
		if (! defined $msg[$i]) {
			$msg[$i] = $UNDEF;
		}
	}

	# Get calling stack.
	my @stack = _get_stack();

	# Create errors message.
	push @ERRORS, {
		'msg' => \@msg,
		'stack' => \@stack,
	};

	return @ERRORS;
}

# Get information about place of error.
sub _get_stack {
	my $max_level = shift || $MAX_LEVELS;
	my @stack;
	my $tmp_level = $LEVEL;
	my ($class, $prog, $line, $sub, $hargs, $evaltext, $is_require);
	while ($tmp_level < $max_level
		&& do { package DB; ($class, $prog, $line, $sub, $hargs,
		undef, $evaltext, $is_require) = caller($tmp_level++); }) {

		# Prog to absolute path.
		if (-e $prog) {
			$prog = abs_path($prog);
		}

		# Sub name.
		if (defined $evaltext) {
			if ($is_require) {
				$sub = "require $evaltext";
			} else {
				$evaltext =~ s/\n;//sm;
				$evaltext =~ s/([\'])/\\$1/gsm;
				if ($MAX_EVAL
					&& length($evaltext) > $MAX_EVAL) {

					substr($evaltext, $MAX_EVAL, -1,
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
			if ($sub =~ m/^Error::Pure::(.*)err$/smx) {
				$sub = 'err';
			}
			if ($PROGRAM && $prog =~ m/^\(eval/sm) {
				$prog = $PROGRAM;
			}
		}

		# Args.
		my $i_args = $EMPTY_STR;
		if ($hargs) {
			my @args = @DB::args;
			if ($MAX_ARGS && $#args > $MAX_ARGS) {
				$#args = $MAX_ARGS;
				$args[-1] = $DOTS;
			}

			# Get them all.
			foreach my $arg (@args) {
				if (! defined $arg) {
					$arg = 'undef';
					next;
				}
				if (ref $arg) {

					# Force string representation.
					$arg .= $EMPTY_STR;
				}
				$arg =~ s/'/\\'/gms;
				if ($MAX_ARG_LEN && length $arg> $MAX_ARG_LEN) {
					substr $arg, $MAX_ARG_LEN, -1, $DOTS;
				}

				# Quote (not for numbers).
				if ($arg !~ m/^-?[\d.]+$/ms) {
					$arg = "'$arg'";
				}
			}
			$i_args = '('.(join ', ', @args).')';
		}

		# Information to stack.
		$sub =~ s/\n$//ms;
		push @stack, {
			'class' => $class,
			'prog' => $prog,
			'line' => $line,
			'sub' => $sub,
			'args' => $i_args
		};
	}

	# Stack.
	return @stack;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure::Utils - Utilities for structured errors.

=head1 SYNOPSIS

 use Error::Pure::Utils qw(clean err_get err_helper);
 clean();
 my @errors = err_get(1);
 my @errors = err_helper('This is a fatal error', 'name', 'value');

=head1 SUBROUTINES

=over 8

=item B<clean()>

 Resets internal variables with errors.
 Is exportable.

=item B<err_get([$clean])>

 Get and clean processed errors.
 err_get() returns error structure.
 err_get(1) returns error structure and delete it internally.
 Returns array of errors.
 Is exportable.

=item B<err_helper(@msg)>

 Subroutine for additional module above Error::Pure.
 @msg is array of messages.
 Returns array of errors.
 Is exportable.

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

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Dumpvalue;
 use Error::Pure::Die qw(err);
 use Error::Pure::Utils qw(err_get);

 # Error in eval.
 eval { err '1', '2', '3'; };

 # Error structure.
 my @err = err_get();

 # Dump.
 my $dump = Dumpvalue->new;
 $dump->dumpValues(\@err);

 # In \@err:
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
 #                                 'prog' => 'script.pl',
 #                                 'sub' => 'err',
 #                         },
 #                         {
 #                                 'args' => '',
 #                                 'class' => 'main',
 #                                 'line' => '9',
 #                                 'prog' => 'script.pl',
 #                                 'sub' => 'eval {...}',
 #                         },
 #                 ],
 #         },
 # ],

=head1 DEPENDENCIES

L<Cwd>,
L<Exporter>,
L<Readonly>.

=head1 SEE ALSO

L<Error::Pure>,
L<Error::Pure::AllError>,
L<Error::Pure::Error>,
L<Error::Pure::ErrorList>,
L<Error::Pure::HTTP::AllError>,
L<Error::Pure::HTTP::Error>,
L<Error::Pure::HTTP::ErrorList>,
L<Error::Pure::HTTP::Print>,
L<Error::Pure::Output::Text>,
L<Error::Pure::Print>.

=head1 REPOSITORY

L<https://github.com/tupinek/Error-Pure>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.10

=cut
