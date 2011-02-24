#------------------------------------------------------------------------------
package Error::Pure::Clean;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub clean {
#------------------------------------------------------------------------------
# Remove call stack after value.

	my ($errors, $value) = @_;

	# Check to structure.
	if (ref $errors ne 'HASH' || ref $value ne 'ARRAY') {
		return;
	}

	my @arr;
	my $log = 0;
	foreach my $st (@{$errors->{'stack'}}) {
		unless ($log == 1 
			|| ($st->{'class'} eq $value->[0] 
			&& $st->{'prog'} eq $value->[1]
			&& $st->{'line'} eq $value->[2])) {

			push @arr, $st;

		# Remove this records.
		} else {

			# After this record, all delete.
			$log = 1;
		}
	}
	$errors->{'stack'} = \@arr;
	return;
}

1;
