# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Error qw(err);
use Test::More 'tests' => 2;

# Test.
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n");

# Test.
eval {
	err 'Error.';
};
my $tmp = $EVAL_ERROR;
eval {
	err $tmp;
};
is($EVAL_ERROR, "Error.\n");
