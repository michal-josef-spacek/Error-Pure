use strict;
use warnings;

use Error::Pure::Print;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Error::Pure::Print::VERSION, 0.34, 'Version.');
