package Error::Pure::Output::Text;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err_bt_pretty err_line err_line_all);
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.16;

# Pretty print of backtrace.
sub err_bt_pretty {
	my @errors = @_;
	my @ret;
	my $l_ar = _lenghts(@errors);
	foreach my $error_hr (@errors) {
		my @msg = @{$error_hr->{'msg'}};
		my $e = shift @msg;
		chomp $e;
		push @ret, 'ERROR: '.$e;
		while (@msg) {
			my $f = shift @msg;
			my $t = shift @msg;

			if (! defined $f) {
				last;
			}
			my $ret = $f;
			if (defined $t) {
				$ret .= ': '.$t;
			}
			push @ret, $ret;
		}
		foreach my $i (0 .. $#{$error_hr->{'stack'}}) {
			my $st = $error_hr->{'stack'}->[$i];
			my $ret = $st->{'class'};
			$ret .=  $SPACE x ($l_ar->[0] - length $st->{'class'});
			$ret .=  $st->{'sub'};
			$ret .=  $SPACE x ($l_ar->[1] - length $st->{'sub'});
			$ret .=  $st->{'prog'};
			$ret .=  $SPACE x ($l_ar->[2] - length $st->{'prog'});
			$ret .=  $st->{'line'};
			push @ret, $ret;
		}
	}
	return wantarray ? @ret : (join "\n", @ret)."\n";
}

sub err_line_all {
	my @errors = @_;
	my $ret;
	foreach my $error_hr (@errors) {
		$ret .= _err_line($error_hr);
	}
	return $ret;
}

# Pretty print line error.
sub err_line {
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

 use Error::Pure::Output::Text qw(err_bt_pretty err_line err_line_all);
 print err_bt_pretty(@errors);
 print err_line_all(@errors);
 print err_line(@errors);

=head1 SUBROUTINES

=over 8

=item C<err_bt_pretty(@errors)>

 Returns string with full backtrace in scalar context.
 Returns array of full backtrace lines in array context.
 Format of error is:
         ERROR: %s
         %s: %s
         ...
         %s %s %s %s
         ...
 Values of error are:
         message
         message as key, $message as value
         ...
         sub, caller, program, line

=item C<err_line_all(@errors)>

 Returns string with errors each on one line.
 Use all errors in @errors structure.
 Format of error line is: "#Error [%s:%s] %s\n"
 Values of error line are: $program, $line, $message

=item C<err_line(@errors)>

 Returns string with error on one line.
 Use last error in @errors structure..
 Format of error is: "#Error [%s:%s] %s\n"
 Values of error are: $program, $line, $message

=back

=head1 ERRORS

 None.

=head1 EXAMPLE1

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Output::Text qw(err_bt_pretty);

 # Fictional error structure.
 my $err_hr = {
         'msg' => [
                 'FOO',
                 'KEY',
                 'VALUE',
         ],
         'stack' => [
                 {
                         'args' => '(2)',
                         'class' => 'main',
                         'line' => 1,
                         'prog' => 'script.pl',
                         'sub' => 'err',
                 }, {
                         'args' => '',
                         'class' => 'main',
                         'line' => 20,
                         'prog' => 'script.pl',
                         'sub' => 'eval {...}',
                 }
         ],
 };

 # Print out.
 print scalar err_bt_pretty($err_hr);

 # Output:
 # ERROR: FOO
 # KEY: VALUE
 # main  err         script.pl  1
 # main  eval {...}  script.pl  20

=head1 EXAMPLE2

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Output::Text qw(err_line_all);

 # Fictional error structure.
 my @err = (
         {
                 'msg' => [
                         'FOO',
                         'BAR',
                 ],
                 'stack' => [
                         {
                                 'args' => '(2)',
                                 'class' => 'main',
                                 'line' => 1,
                                 'prog' => 'script.pl',
                                 'sub' => 'err',
                         }, {
                                 'args' => '',
                                 'class' => 'main',
                                 'line' => 20,
                                 'prog' => 'script.pl',
                                 'sub' => 'eval {...}',
                         }
                 ],
         }, {
                 'msg' => ['XXX'],
                 'stack' => [
                         {
                                 'args' => '',
                                 'class' => 'main',
                                 'line' => 2,
                                 'prog' => 'script.pl',
                                 'sub' => 'err',
                         },
                 ],
         }
 );

 # Print out.
 print err_line_all(@err);

 # Output:
 # #Error [script.pl:1] FOO
 # #Error [script.pl:2] XXX

=head1 EXAMPLE3

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Output::Text qw(err_line);

 # Fictional error structure.
 my $err_hr = {
         'msg' => [
                 'FOO',
                 'BAR',
         ],
         'stack' => [
                 {
                         'args' => '(2)',
                         'class' => 'main',
                         'line' => 1,
                         'prog' => 'script.pl',
                         'sub' => 'err',
                 }, {
                         'args' => '',
                         'class' => 'main',
                         'line' => 20,
                         'prog' => 'script.pl',
                         'sub' => 'eval {...}',
                 }
         ],
 };

 # Print out.
 print err_line($err_hr);

 # Output:
 # #Error [script.pl:1] FOO

=head1 DEPENDENCIES

L<Exporter>,
L<Readonly>.

=head1 SEE ALSO

L<Error::Pure>,
L<Error::Pure::AllError>,
L<Error::Pure::Die>,
L<Error::Pure::Error>,
L<Error::Pure::ErrorList>,
L<Error::Pure::Print>,
L<Error::Pure::Utils>,

=head1 REPOSITORY

L<https://github.com/tupinek/Error-Pure>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.16

=cut
