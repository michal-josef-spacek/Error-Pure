# Modules.
use Error::Pure::Error;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::Error::VERSION, '0.01');
