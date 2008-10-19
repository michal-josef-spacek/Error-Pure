#------------------------------------------------------------------------------
package Error::Pure;
#------------------------------------------------------------------------------

# Pragmas.
use strict;

# Modules.
use Exporter;

# Global variables.
use vars qw/@errors/;

# Export.
our @EXPORT = qw(err_get);
our @EXPORT_OK = qw(_err);

# Inheritance.
our @ISA = qw(Exporter);

# Version.
our $VERSION = 0.01;

# Default initialization.
our $level = 2;
our $max_levels = 50;
our $max_eval = 100;
our $max_args = 10;
our $max_arg_len = 50;
our $program = '';       # Program name in stack information.

# Constants.
use constant EVAL => 'eval {...}';

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

#------------------------------------------------------------------------------
sub err(@) {
#------------------------------------------------------------------------------
# Process error.

	my $msg = \@_;
	my $errors = _err($msg);
	my $tmp = $errors->[-1]->{'stack'}->[0];
	CORE::die $msg->[0]." at $tmp->{'prog'} line $tmp->{'line'}.\n";
}

#------------------------------------------------------------------------------
sub err_get(;$) {
#------------------------------------------------------------------------------
# Get and clean processed errors.

	my $clean = shift;
	my @ret = @errors;
	@errors = () unless $clean;
	return wantarray ? @ret : \@ret;
}

#------------------------------------------------------------------------------
# Private functions.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _err($) {
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
sub _get_stack(;$) {
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
				$evaltext =~ s/([\\\'])/\\$1/g;
				if ($max_eval 
					&& length($evaltext) > $max_eval) {

					substr($evaltext, $max_eval) = '...';
				}
				$sub = "eval '$evaltext'";
			}

		# My eval name.
		} elsif ($sub eq '(eval)') {
			$sub = EVAL;

		# Other transformation.
		} else {
			$sub =~ s/^$class\:\:([^:]+)$/$1/g;
			$sub = 'die' if $sub =~ /^Error::Pure::(.*)err$/;
			$prog = $program if $program && $prog =~ /^\(eval/;
		}

		# Args.
		my $i_args = '';
		if ($hargs) {
			my @args = @DB::args;
			if ($max_args && $#args > $max_args) {
				$#args = $max_args;
				$args[-1] = '...';
			}

			# Get them all.
			foreach (@args) {
				$_ = 'undef', next unless defined $_;
				if (ref $_) {

					# Force string representation.
					$_ .= '';
				}
				s/'/\\'/g;
				if ($max_arg_len && length > $max_arg_len) {
					substr($_, $max_arg_len) = '...';
				}

				# Quote (not for numbers).
				$_ = "'$_'" unless /^-?[\d.]+$/;
			}
			$i_args = '('.join(', ', @args).')';
		}

		# Information to stack.
		$sub =~ s/\n//;
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
