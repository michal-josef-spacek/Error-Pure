# Modules.
use Test::More 'tests' => 2;

BEGIN {

	# Debug message.
	print "Usage tests.\n";

	# Test.
	use_ok('Error::Pure::ErrorList');
}

# Test.
require_ok('Error::Pure::ErrorList');