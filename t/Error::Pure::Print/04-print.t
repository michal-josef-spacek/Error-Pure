# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Pure::Print qw(err);
use English qw(-no_match_vars);
use File::Object;
use Test::More 'tests' => 2;

# Path to dir with T.pm. And load T.pm.
my $current_dir;
BEGIN {
	$current_dir = File::Object->new;
	unshift @INC, $current_dir->s;
};
use T;

# Test.
eval {
	err 'Error.';
};
is($EVAL_ERROR, 'Error.'."\n");

# Test.
eval {
	T::example;
};
is($EVAL_ERROR, 'Something.'."\n");

# TODO Test to normal output? fork? system?
#ok($@, 'T: Something.'."\n");
