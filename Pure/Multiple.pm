#------------------------------------------------------------------------------
package Error::Pure::Multiple;
#------------------------------------------------------------------------------

# Pragmas.
use strict;

# Modules.
use Error::Pure qw();

# Version.
our $VERSION = 0.01;

# Type of error.
our $type = 'Print';

# Level for this class.
our $level = 4;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

#------------------------------------------------------------------------------
sub err(@) {
#------------------------------------------------------------------------------
# Process error.

	my @msg = @_;
	$Error::Pure::level = $level;
	my $class = $type ? 'Error::Pure::'.$type : 'Error::Pure';
	eval "require $class";
	eval $class."::err \@msg";
	CORE::die $@ if $@;
}

BEGIN {
        *CORE::GLOBAL::die = \&err;
}

1;
