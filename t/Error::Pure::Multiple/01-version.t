# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Multiple;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::Multiple::VERSION, '0.01', 'Version.');
