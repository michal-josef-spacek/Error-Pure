use strict;
use warnings;

use Error::Pure::Die;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Error::Pure::Die::VERSION, 0.34, 'Version.');
