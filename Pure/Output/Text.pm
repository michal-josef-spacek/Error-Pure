package Error::Pure::Output::Text;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Array our @EXPORT => qw(err_bt_pretty err_bt_simple err_pretty);
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.01;

# Pretty print of backtrace.
sub err_bt_pretty {
	my $errors_ar = shift;
	my $ret;
	my $l_ar = _lenghts($errors_ar);
	foreach my $error_hr (@{$errors_ar}) {
		my $e = shift @{$error_hr->{'msg'}};
		chomp $e;
		$ret .= 'ERROR: '.$e."\n";
		while (@{$error_hr->{'msg'}}) {
			my $f = shift @{$error_hr->{'msg'}};
			my $t = shift @{$error_hr->{'msg'}};

			if (! defined $f) {
				last;
			}
			$ret .= $f;
			if ($t) {
				$ret .= ': '.$t;
			}
			$ret .= "\n";
		}
		foreach my $i (0 .. $#{$error_hr->{'stack'}}) {
			my $st = $error_hr->{'stack'}->[$i];
			$ret .= $st->{'class'};
			$ret .=  $SPACE x ($l_ar->[0] - length $st->{'class'});
			$ret .=  $st->{'sub'};
			$ret .=  $SPACE x ($l_ar->[1] - length $st->{'sub'});
			$ret .=  $st->{'prog'};
			$ret .=  $SPACE x ($l_ar->[2] - length $st->{'prog'});
			$ret .=  $st->{'line'};
			$ret .= "\n";
		}
	}
	return $ret;
}

sub err_bt_simple {
	my $errors_ar = shift;
	my $ret;
	foreach my $error_hr (@{$errors_ar}) {
		$ret .= _err_line($error_hr);
	}
	return $ret;
}

# Pretty print line error.
sub err_pretty {
	my $errors_ar = shift;
	return _err_line($errors_ar->[-1]);
}

# Gets length for errors.
sub _lenghts {
	my $errors_ar = shift;
	my $l_ar = [0, 0, 0];
	foreach my $error_hr (@{$errors_ar}) {
		foreach my $st (@{$error_hr->{'stack'}}) {
			if (length $st->{'class'} > $l_ar->[0]) {
				$l_ar->[0] = length $st->{'class'};
			}
			if (length $st->{'sub'} > $l_ar->[1]) {
				$l_ar->[1] = length $st->{'sub'};
			}
			if (length $st->{'prog'} > $l_ar->[2]) {
				$l_ar->[2] = length $st->{'prog'};
			}
		}
	}
	$l_ar->[0] += 2;
	$l_ar->[1] += 2;
	$l_ar->[2] += 2;
	return $l_ar;
}

# Pretty print line error.
sub _err_line {
	my $error_hr = shift;
	my $stack_ar = $error_hr->{'stack'};
	my $msg = $error_hr->{'msg'};
	my $prog = $stack_ar->[0]->{'prog'};
	$prog =~ s/^\.\///gms;
	my $e = $msg->[0];
	chomp $e;
	return "#Error [$prog:$stack_ar->[0]->{'line'}] $e\n";
}

1;
