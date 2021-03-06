#!/usr/bin/env perl

use strict;
use warnings;

use Error::Pure qw(err);

$SIG{__DIE__} = sub {
        my $err = shift;
        $err =~ s/ at .*\n//ms;
        $Error::Pure::LEVEL = 5;
        $Error::Pure::TYPE = 'ErrorList';
        err $err;
};

# Error.
die 'Error';

# Output.
# #Error [path_to_script.pl:17] Error