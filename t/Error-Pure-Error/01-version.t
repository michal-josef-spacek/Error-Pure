# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Error;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::Error::VERSION, 0.03, 'Version.');
