# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Clean qw(clean);
use Error::Pure::Utils qw(err_get);
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
	T::error2;
};
is($EVAL_ERROR, "Second error in T2 class.\n");

# Test.
my $errors = err_get();
my $right_ret = [{
	'msg' => ['Error in T2 class.'],
	'stack' => [{
		'args' => '(\'Error in T2 class.\')',
		'class' => 'T',
		'line' => 15,
		'prog' => $current_dir->file('T.pm')->s,
		'sub' => 'err',
	}, {
		'args' => '()',
		'class' => 'T',
		'line' => 21,
		'prog' => $current_dir->file('T.pm')->s,
		'sub' => 'error',
	}, {
		'args' => '',
		'class' => 'T',
		'line' => 20,
		'prog' => $current_dir->file('T.pm')->s,
		'sub' => 'eval {...}',
	}],
}, {
	'msg' => ['Second error in T2 class.'],
	'stack' => [{
		'args' => '(\'Second error in T2 class.\')',
		'class' => 'T',
		'line' => 27,
		'prog' => $current_dir->file('T.pm')->s,
		'sub' => 'err',
	}, {
		'args' => '()',
		'class' => 'main',
		'line' => 22,
		'prog' => $current_dir->file('04-clean.t')->s,
		'sub' => 'T::error2',
	}, {
		'args' => '',
		'class' => 'main',
		'line' => 21,
		'prog' => $current_dir->file('04-clean.t')->s,
		'sub' => 'eval {...}',
	}],
}];
is_deeply($errors, $right_ret);
