# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure::Die qw(err);
use Error::Pure::Utils qw(clean err_get);
use Test::More 'tests' => 2;

# Test.
my $eval_string = <<'END';
	my $x = 'abc abc abc abc abc abc abc abc abc abc abc abc';
	$x = 'dba dba dba dba dba dba dba dba dba dba dba dba';
	err 'Error.';
END
eval $eval_string;
my @err = err_get();
my $print_eval_string = $eval_string;
$print_eval_string =~ s/([\'])/\\$1/gsm;
if (length $print_eval_string > 100) {
	substr $print_eval_string, 100, -1, '...';
}
is($err[0]->{'stack'}->[1]->{'sub'}, "eval '$print_eval_string'");

# Test.
clean();
$Error::Pure::Utils::MAX_EVAL = '10';
eval $eval_string;
@err = err_get();
$print_eval_string = $eval_string;
$print_eval_string =~ s/([\'])/\\$1/gsm;
if (length $print_eval_string > 10) {
	substr $print_eval_string, 10, -1, '...';
}
is($err[0]->{'stack'}->[1]->{'sub'}, "eval '$print_eval_string'");
