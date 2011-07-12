# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::ErrorList;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::ErrorList::VERSION, 0.02, 'Version.');
