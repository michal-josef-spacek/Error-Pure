# Pragmas.
use strict;
use warnings;

# Modules.
use FindBin qw($Bin);
use English qw(-no_match_vars);
use Error::Pure::Print qw(err);
use Test::More 'tests' => 3;

# Path to dir with T.pm. And load T.pm.
BEGIN {
	unshift @INC, $Bin;
};
use T;

# Test.
eval {
	err 'Error.';
};
is($EVAL_ERROR, 'Error.'."\n");

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
eval {
	T::example;
};
is($EVAL_ERROR, 'Something.'."\n");
