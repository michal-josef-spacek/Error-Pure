package Error::Pure::Error;

# Pragmas.
use base qw(Exporter);
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(err_helper);
use Error::Pure::Output::Text qw(err_pretty);
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

		CORE::die Error::Pure::Output::Text::err_pretty($errors);

	# Die for eval.
	} else {
		CORE::die "$msg->[0]\n";
	}
}

1;
