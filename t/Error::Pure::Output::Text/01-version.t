# Modules.
use Error::Pure::Output::Text;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: version.\n";

# Test.
is($Error::Pure::Output::Text::VERSION, '0.03');
