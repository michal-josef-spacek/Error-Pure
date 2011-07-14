# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Output::Text;
use Test::More 'tests' => 1;

# Test.
is($Error::Pure::Output::Text::VERSION, 0.04, 'Version.');
