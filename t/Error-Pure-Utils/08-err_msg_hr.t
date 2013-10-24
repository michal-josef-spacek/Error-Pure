# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Utils qw(clean err_helper err_msg_hr);
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
err_helper('Error', 'key1', 'val1', 'key2', 'val2');
my $ret_hr = err_msg_hr();
is_deeply(
	$ret_hr,
	{
		'key1' => 'val1',
		'key2' => 'val2',
	},
	'Simple test.',
);
clean();
