#------------------------------------------------------------------------------
package Error::Pure::Multiple;
#------------------------------------------------------------------------------

# Pragmas.
use strict;

# Modules.
use Error::Pure qw();
use Exporter;

# Export.
our @EXPORT = qw(err);

# Inheritance.
our @ISA = qw(Exporter);

# Version.
our $VERSION = 0.01;

# Type of error.
our $type = 'Print';

# Level for this class.
our $level = 4;

#------------------------------------------------------------------------------
sub err(@) {
#------------------------------------------------------------------------------
# Process error.

	my @msg = @_;
	$Error::Pure::level = $level;
	my $class = $type ? 'Error::Pure::'.$type : 'Error::Pure';
	eval "require $class";
	eval $class."::err \@msg";
	die $@ if $@;
}

1;
