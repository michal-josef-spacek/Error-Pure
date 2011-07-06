# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::AllError qw(err);
use Test::More 'tests' => 1;

# Test.
eval {
	err 'Error.';
};
is($EVAL_ERROR, "Error.\n");

# TODO Test to normal output? fork? system?
#my $right_ret = <<"END";
#ERROR: Error.
#main  err                                           t/ErrorSimpleAllError/02_all_error.t  5
#main  eval {...}                                    t/ErrorSimpleAllError/02_all_error.t  4
#main  require t/ErrorSimpleAllError/02_all_error.t  t/06_error_simple_all_error.t         35
#END
#ok($@, $right_ret);
