# Modules.
use Test::Pod::Coverage 'tests' => 1;

# Debug message.
print "Testing: Pod coverage.\n";

# Test.
pod_coverage_ok('Error::Pure::Output::Text',
	'Error::Pure::Output::Text is covered.');
