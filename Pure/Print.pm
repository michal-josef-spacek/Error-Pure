#------------------------------------------------------------------------------
package Error::Pure::Print;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure qw(err_helper);

# Version.
our $VERSION = 0.01;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

#------------------------------------------------------------------------------
sub err {
#------------------------------------------------------------------------------
# Process error.

	my $msg = \@_;
	my $errors = err_helper(@{$msg});

	# Finalize in main on last err.
	my $stack = $errors->[-1]->{'stack'};
	if ($stack->[-1]->{'class'} eq 'main'
		&& ! grep({ $_ eq 'eval {...}' || $_ =~ /^eval '/} 
		map { $_->{'sub'} } @{$stack})) {

		my $class = $errors->[-1]->{'stack'}->[0]->{'class'};
		if ($class eq 'main') {
			$class = '';
		}
		if ($class) {
			$class .= ': ';
		}
		CORE::die $class."$msg->[0]\n";

	# Die for eval.
	} else {
		CORE::die "$msg->[0]\n";
	}
}

BEGIN {
	no warnings qw(redefine);
        *CORE::GLOBAL::die = \&err;
}

1;
