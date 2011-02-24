#------------------------------------------------------------------------------
package Error::Pure::Multiple;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure qw();
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err);
Readonly::Scalar my $TYPE_DEFAULT => 'Print';
Readonly::Scalar my $LEVEL_DEFAULT => 4;

# Version.
our $VERSION = 0.01;

# Type of error.
our $TYPE = $TYPE_DEFAULT;

# Level for this class.
our $LEVEL = $LEVEL_DEFAULT;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

#------------------------------------------------------------------------------
sub err {
#------------------------------------------------------------------------------
# Process error.

	my @msg = @_;
	$Error::Pure::LEVEL = $LEVEL;
	my $class = $TYPE ? 'Error::Pure::'.$TYPE : 'Error::Pure';
	eval "require $class";
	eval $class.'::err @msg';
	if ($EVAL_ERROR) {
		CORE::die "$@";
	}
	return;
}

BEGIN {
	no warnings qw(redefine);
        *CORE::GLOBAL::die = \&err;
}

1;
