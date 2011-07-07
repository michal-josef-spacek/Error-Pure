# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure qw(err);
use Test::More 'tests' => 4;

# Test.
if (exists $ENV{'ERROR_PURE_TYPE'}) {
	delete $ENV{'ERROR_PURE_TYPE'};
}
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n", 'Default TYPE variable.');

# Test.
$Error::Pure::TYPE = undef;
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n", 'Undefined TYPE variable.');

# Test.
$Error::Pure::TYPE = 'Print';
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n", 'Explicit TYPE variable.');

# Test.
$Error::Pure::TYPE = 'Die';
$ENV{'ERROR_PURE_TYPE'} = 'Error';
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n", 'TYPE in environment variable.');
