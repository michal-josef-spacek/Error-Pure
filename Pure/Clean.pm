package Error::Pure::Clean;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(clean);

# Version.
our $VERSION = 0.01;

# Remove call stack after value.
sub clean {
	my ($errors_hr, $value_ar) = @_;

	# Check to structure.
	if (ref $errors_hr ne 'HASH' || ref $value_ar ne 'ARRAY') {
		return;
	}

	# Filter values.
	my @arr;
	my $log = 0;
	foreach my $st_hr (@{$errors_hr->{'stack'}}) {
		if ($log == 0
			&& ($st_hr->{'class'} ne $value_ar->[0] 
			|| $st_hr->{'prog'} ne $value_ar->[1]
			|| $st_hr->{'line'} ne $value_ar->[2])) {

			push @arr, $st_hr;

		# Remove this records.
		} else {

			# After this record, all delete.
			$log = 1;
		}
	}
	$errors_hr->{'stack'} = \@arr;
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Error::Pure::Clean - Clean utilities for Error::Pure.

=head1 SYNOPSIS

 use Error::Pure::Clean qw(clean);
 clean($err_hr, ['main', $path_to_script, $line]);

=head1 SUBROUTINES

=over 8

=item B<clean($errors_hr, $value_ar)>

 Clean error from $errors_hr hash with $value_ar values.
 $value_ar is reference to array with:
 - class name or 'main'
 - file path
 - line in filename

=back

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Error::Pure::Clean qw(clean);

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
L<Error::Pure::Output::Text(3pm)>,
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
