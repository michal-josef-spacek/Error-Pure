package Error::Pure;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Utils qw();
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

# Process error.
sub err {
	my @msg = @_;
	$Error::Pure::Utils::LEVEL = $LEVEL;
	my $class = $TYPE ? 'Error::Pure::'.$TYPE : 'Error::Pure::Die';
	eval "require $class";
	eval $class.'::err @msg';
	if ($EVAL_ERROR) {
		CORE::die $EVAL_ERROR;
	}
	return;
}

1;
