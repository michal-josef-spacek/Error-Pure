package T;

# Pragmas.
use strict;
use warnings;

# Modules.
use Cwd qw(abs_path);
use English qw(-no_match_vars);
use Error::Pure::AllError qw(err);
use Error::Pure::Clean qw(clean);
use Error::Pure::Utils qw(err_get);

# Example error function.
sub error {
	err 'Error in T2 class.';
}

# Example error function.
sub error2 {
	eval {
		error();
	};
	if ($EVAL_ERROR) {
		my @data = caller;
		$data[1] = abs_path($data[1]);
		my @errors = err_get();
		clean($errors[-1], \@data);
		err 'Second error in T2 class.';
	}
}

1;
