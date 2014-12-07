# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Error;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Error::Pure::Error::VERSION, 0.2, 'Version.');
