# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(err_get);
use Test::More 'tests' => 6;

# Test.
@Error::Pure::Utils::ERRORS = qw(FOO BAR);
my @ret = err_get();
is_deeply(
	\@ret,
	[
		'FOO',
		'BAR',
	],
	'Simple test as array.',
);
is_deeply(
	\@Error::Pure::Utils::ERRORS,
	[
		'FOO',
		'BAR',
	],
	'@ERRORS variable control.',
);

# Test.
my $ret_ar = err_get();
is_deeply(
	$ret_ar,
	[
		'FOO',
		'BAR',
	],
	'Simple test as reference to array.',
);
is_deeply(
	\@Error::Pure::Utils::ERRORS,
	[
		'FOO',
		'BAR',
	],
	'@ERRORS variable control.',
);

# Test.
@ret = err_get(1);
is_deeply(
	\@ret,
	[
		'FOO',
		'BAR',
	],
	'Simple test as array. With cleaning.',
);
is_deeply(
	\@Error::Pure::Utils::ERRORS,
	[],
	'Cleaning control.',
);
