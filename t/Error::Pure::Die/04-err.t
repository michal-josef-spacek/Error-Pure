# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Die qw(err);
use Test::More 'tests' => 3;

# Test.
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n", 'Simple message in eval.');

# Test.
eval {
	err 'Error.', 1, 2;
};
is($EVAL_ERROR, "Error.\n", 'More messages in eval.');

# Test.
eval {
	err 'Error.';
};
my $tmp = $EVAL_ERROR;
eval {
	err $tmp;
};
is($EVAL_ERROR, "Error.\n", 'More evals.');
