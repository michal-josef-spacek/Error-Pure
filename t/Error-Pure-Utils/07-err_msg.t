# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(clean err_helper err_msg);
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
err_helper('FOO', 'BAR');
my @ret = err_msg();
is_deeply(
	\@ret,
	[
		'FOO',
		'BAR',
	],
	'Simple test.',
);
clean();
