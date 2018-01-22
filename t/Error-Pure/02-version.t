# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Error::Pure::VERSION, 0.26, 'Version.');
