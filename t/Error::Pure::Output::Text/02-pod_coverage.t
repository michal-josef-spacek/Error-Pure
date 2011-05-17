# Pragmas.
use strict;
use warnings;

# Modules.
use Test::Pod::Coverage 'tests' => 1;

# Test.
pod_coverage_ok('Error::Pure::Output::Text', 'Error::Pure::Output::Text is covered.');
