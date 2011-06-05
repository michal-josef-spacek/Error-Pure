package Error::Pure::Print;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(err_helper);
use Readonly;

# Constants.
Readonly::Array our @EXPORT_OK => qw(err);

# Version.
our $VERSION = 0.01;

# Ignore die signal.
$SIG{__DIE__} = 'IGNORE';

# Process error.
sub err {
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
		die $class."$msg->[0]\n";

	# Die for eval.
	} else {
		die "$msg->[0]\n";
	}
}

1;
