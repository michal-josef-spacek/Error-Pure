# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::AllError;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::AllError::VERSION, 0.09, 'Version.');
