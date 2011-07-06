# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Error qw(err);
use Test::More 'tests' => 1;

# Test.
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n");

# TODO Test to normal output? fork? system?
#ok($@, '#Error [t/ErrorSimpleError/02_error.t:5] Error.'."\n");
