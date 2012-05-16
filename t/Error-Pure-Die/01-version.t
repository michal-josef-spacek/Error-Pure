# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Die;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::Die::VERSION, 0.08, 'Version.');
