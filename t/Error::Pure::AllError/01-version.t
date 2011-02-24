# Modules.
use Error::Pure::AllError;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::AllError::VERSION, '0.01');
