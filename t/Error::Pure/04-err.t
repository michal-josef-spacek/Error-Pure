# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure qw(err);
use Test::More 'tests' => 5;

# Test.
if (exists $ENV{'ERROR_PURE_TYPE'}) {
	delete $ENV{'ERROR_PURE_TYPE'};
}
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n", 'Default TYPE variable.');

# Test.
eval {
	err 'Error.';
};
my $tmp = $EVAL_ERROR;
eval {
	err $tmp;
};
is($EVAL_ERROR, "Error.\n");

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
