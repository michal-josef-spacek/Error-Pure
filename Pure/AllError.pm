package Error::Pure::AllError;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure qw(err_helper);
use Error::Pure::Output::Text qw(err_bt_pretty);
use List::MoreUtils qw(none);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err);
Readonly::Scalar my $EVAL => 'eval {...}';

# Version.
our $VERSION = 0.01;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

# Process error.
sub err {
	my @msg = @_;

	# Get errors structure.
	my $errors_ar = err_helper(@msg);

	# Finalize in main on last err.
	my $stack_ar = $errors_ar->[-1]->{'stack'};
	if ($stack_ar->[-1]->{'class'} eq 'main'
		&& none { $_ eq $EVAL || $_ =~ m/^eval '/ms }
		map { $_->{'sub'} } @{$stack_ar}) {

		CORE::die err_bt_pretty($errors_ar);

	# Die for eval.
	} else {
		my $e = $errors_ar->[-1]->{'msg'}->[0];
		chomp $e;
		CORE::die "$e\n";
	}
	return;
}

BEGIN {
	no warnings qw(redefine);
        *CORE::GLOBAL::die = \&err;
}

1;
