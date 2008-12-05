#------------------------------------------------------------------------------
package Error::Pure;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Global variables.
use vars qw/@errors/;

# Export.
our @EXPORT = qw(clean err_get);
our @EXPORT_OK = qw(_err);

# Version.
our $VERSION = 0.01;

# Constants.
Readonly::Scalar my $EMPTY => q{};
Readonly::Scalar my $EVAL => 'eval {...}';
Readonly::Scalar my $DOTS => '...';

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

	@errors = ();
	return;
}

#------------------------------------------------------------------------------
sub err {
#------------------------------------------------------------------------------
# Process error.

	my @args = @_;
	my $msg = \@args;
	my $errors = _err($msg);
	my $tmp = $errors->[-1]->{'stack'}->[0];
	CORE::die $msg->[0]." at $tmp->{'prog'} line $tmp->{'line'}.\n";
	return;
}

#------------------------------------------------------------------------------
sub err_get {
#------------------------------------------------------------------------------
# Get and clean processed errors.

	my $clean = shift;
	my @ret = @errors;
	clean() if $clean;
	return wantarray ? @ret : \@ret;
}

#------------------------------------------------------------------------------
# Private functions.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _err {
#------------------------------------------------------------------------------
# Process error without die.

	my $msg = shift;
	my $stack = [];

	# Get calling stack.
	$stack = _get_stack();

	# Create errors message.
	push @errors, {
		'msg' => $msg,
		'stack' => $stack,
	};

	return \@errors;
}

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
			$sub = 'err' if $sub =~ /^Error::Simple::(.*)err$/smx;
			$prog = $program if $program && $prog =~ /^\(eval/sm;
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
				$_ = "'$_'" unless /^-?[\d.]+$/sm;
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
        *CORE::GLOBAL::die = \&err;
}

1;
