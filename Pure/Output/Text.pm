package Error::Pure::Output::Text;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Array our @EXPORT => qw(err_bt_pretty err_bt_simple err_pretty);

# Version.
our $VERSION = 0.01;

# Pretty print of backtrace.
sub err_bt_pretty {
	my $errors = shift;
	my $ret;
	my $l = _lenghts($errors);
	foreach my $error (@{$errors}) {
		my $tmp = shift @{$error->{'msg'}};
		$ret .= "ERROR: ".$tmp."\n";
		while (my ($f, $t) = (shift @{$error->{'msg'}}, 
			shift @{$error->{'msg'}})) {

			if (! defined $f) {
				last;
			}
			$ret .= $f.': '.$t."\n";
		}
		for (my $i = 0; $i <= $#{$error->{'stack'}}; $i++) {
			my $st = $error->{'stack'}->[$i];
			$ret .= $st->{'class'};
			$ret .=  ' ' x ($l->[0] - length $st->{'class'});
			$ret .=  $st->{'sub'};
			$ret .=  ' ' x ($l->[1] - length $st->{'sub'});
			$ret .=  $st->{'prog'};
			$ret .=  ' ' x ($l->[2] - length $st->{'prog'});
			$ret .=  $st->{'line'};
			$ret .= "\n";
		}
	}
	return $ret;
}

# Line print of backtrace.
sub err_bt_simple {
	my $errors = shift;
	my $ret;
	foreach my $error (@{$errors}) {
		$ret .= _err_line($error);
	}
	return $ret;
}

# Pretty print line error.
sub err_pretty {
	my $errors = shift;
	return _err_line($errors->[-1]);
}

# Gets length for errors.
sub _lenghts {
	my $errors = shift;
	my $l = [0, 0, 0];
	foreach my $error (@{$errors}) {
		foreach my $st (@{$error->{'stack'}}) {
			if (length $st->{'class'} > $l->[0]) {
				$l->[0] = length $st->{'class'};
			}
			if (length $st->{'sub'} > $l->[1]) {
				$l->[1] = length $st->{'sub'};
			}
			if (length $st->{'prog'} > $l->[2]) {
				$l->[2] = length $st->{'prog'};
			}
		}
	}
	$l->[0] += 2;
	$l->[1] += 2;
	$l->[2] += 2;
	return $l;
}

# Pretty print line error.
sub _err_line {
	my $error = shift;
	my $stack = $error->{'stack'};
	my $msg = $error->{'msg'};
	my $prog = $stack->[0]->{'prog'};
	$prog =~ s/^\.\///g;
	return "#Error [$prog:$stack->[0]->{'line'}] $msg->[0]\n";
}

1;
