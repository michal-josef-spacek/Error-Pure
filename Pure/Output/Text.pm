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
	my @errors = @_;
	my $ret;
	my $l_ar = _lenghts(@errors);
	foreach my $error_hr (@errors) {
		my @msg = @{$error_hr->{'msg'}};
		my $e = shift @msg;
		chomp $e;
		$ret .= 'ERROR: '.$e."\n";
		while (@msg) {
			my $f = shift @msg;
			my $t = shift @msg;

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
	my @errors = @_;
	my $ret;
	foreach my $error_hr (@errors) {
		$ret .= _err_line($error_hr);
	}
	return $ret;
}

# Pretty print line error.
sub err_pretty {
	my @errors = @_;
	return _err_line($errors[-1]);
}

# Gets length for errors.
sub _lenghts {
	my @errors = @_;
	my $l_ar = [0, 0, 0];
	foreach my $error_hr (@errors) {
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

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure::Output::Text - Output subroutines for Error::Pure.

=head1 SYNOPSIS

 use Error::Pure::Output::Text qw(err_bt_pretty err_bt_simple err_pretty);
 print err_bt_pretty(@errors);
 print err_bt_simple(@errors);
 print err_pretty(@errors);

=head1 SUBROUTINES

=over 8

=item B<err_bt_pretty(@errors)>

TODO

=item B<err_bt_simple(@errors)>

TODO

=item B<err_pretty(@errors)>

TODO

=back

=head1 ERRORS

 None.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Output::Text qw(err_bt_pretty);

 TODO

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Output::Text qw(err_bt_simple);

 TODO

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Output::Text qw(err_pretty);

 TODO

=head1 DEPENDENCIES

L<Exporter(3pm)>,
L<Readonly(3pm)>.

=head1 SEE ALSO

L<Error::Pure(3pm)>,
L<Error::Pure::AllError(3pm)>,
L<Error::Pure::Die(3pm)>,
L<Error::Pure::Error(3pm)>,
L<Error::Pure::ErrorList(3pm)>,
L<Error::Pure::Print(3pm)>,
L<Error::Pure::Utils(3pm)>,

=head1 AUTHOR

 Michal Špaček L<skim@cpan.org>
 http://skim.cz

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
