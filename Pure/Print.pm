#------------------------------------------------------------------------------
package Error::Pure::Print;
#------------------------------------------------------------------------------

# Pragmas.
use strict;

# Modules.
use Error::Pure qw(_err);
use Exporter;

# Export.
our @EXPORT = qw(err);

# Inheritance.
our @ISA = qw(Exporter);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub err(@) {
#------------------------------------------------------------------------------
# Process error.

	my $msg = \@_;
	my $errors = Error::Pure::_err($msg);

	# Finalize in main on last err.
	my $stack = $errors->[-1]->{'stack'};
	if ($stack->[-1]->{'class'} eq 'main'
		&& ! grep({ $_ eq 'eval {...}' || $_ =~ /^eval '/} 
		map { $_->{'sub'} } @{$stack})) {

		my $class = $errors->[-1]->{'stack'}->[0]->{'class'};
		$class = '' if $class eq 'main';
		$class .= ': ' if $class;
		CORE::die $class."$msg->[0]\n";

	# Die for eval.
	} else {
		CORE::die "$msg->[0]\n";
	}
}

BEGIN {
        *CORE::GLOBAL::die = \&err;
}

1;
