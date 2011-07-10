# Pragmas.
use strict;
use warnings;

# Modules.
use Cwd qw(realpath);
use File::Spec::Functions qw(catfile);
use FindBin qw($Bin);
use Test::More 'tests' => 1;
use Test::Pod;

# Test.
pod_file_ok(realpath(catfile($Bin, '..', '..', 'Pure', 'Print.pm')));
