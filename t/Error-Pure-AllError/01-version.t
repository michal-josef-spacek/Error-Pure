# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::AllError;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Error::Pure::AllError::VERSION, 0.13, 'Version.');
