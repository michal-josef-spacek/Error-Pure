# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::ErrorList;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Error::Pure::ErrorList::VERSION, 0.19, 'Version.');
