#------------------------------------------------------------------------------
package Error::Pure::Clean;
#------------------------------------------------------------------------------

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Cwd qw(abs_path);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(clean);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub clean {
#------------------------------------------------------------------------------
# Remove call stack after value.

	my ($errors_hr, $value_ar) = @_;

	# Check to structure.
	if (ref $errors_hr ne 'HASH' || ref $value_ar ne 'ARRAY') {
		return;
	}

	# To absolute path.
	$value_ar->[1] = abs_path($value_ar->[1]);

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
