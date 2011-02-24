# Modules.
use Error::Pure;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::VERSION, '0.01');
