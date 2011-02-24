# Modules.
use Error::Pure::Multiple;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::Multiple::VERSION, '0.01');
