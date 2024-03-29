use strict;
use warnings;

use Cwd qw(realpath);
use English qw(-no_match_vars);
use File::Spec::Functions qw(catfile);
use FindBin qw($Bin);
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
SKIP: {
	if ($PERL_VERSION lt v5.8.0) {
		skip 'Perl version lesser then 5.8.0.', 1;
	}
	require Test::Pod;
	Test::Pod::pod_file_ok(realpath(catfile($Bin, '..', '..', 'Pure',
		'Intent.pod')));
};
