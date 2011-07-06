# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure qw(err);
use Test::More 'tests' => 1;

# Test.
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n");
