# Pragmas.
use strict;
use warnings;

# Modules.
use Test::Pod::Coverage 'tests' => 1;

# Test.
pod_coverage_ok('Error::Pure::Multiple', 'Error::Pure::Multiple is covered.');
