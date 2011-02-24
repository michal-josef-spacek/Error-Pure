# Modules.
use Error::Pure::Clean;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::Clean::VERSION, '0.01');
