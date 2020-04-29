#!/usr/bin/env perl

use strict;
use warnings;

use Error::Pure qw(err);

# Set env error type.
$ENV{'ERROR_PURE_TYPE'} = 'ErrorList';

# Error.
err '1';

# Output something like:
# #Error [path_to_script:12] 1