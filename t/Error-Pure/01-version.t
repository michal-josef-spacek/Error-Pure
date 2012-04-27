# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::VERSION, 0.07, 'Version.');
