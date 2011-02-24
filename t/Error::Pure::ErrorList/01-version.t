# Modules.
use Error::Pure::ErrorList;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::ErrorList::VERSION, '0.01');
