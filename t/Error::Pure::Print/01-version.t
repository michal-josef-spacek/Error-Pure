# Modules.
use Error::Pure::Print;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::Print::VERSION, '0.01');
