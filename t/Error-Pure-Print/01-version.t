# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Print;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::Print::VERSION, 0.08, 'Version.');
