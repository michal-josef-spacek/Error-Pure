#!/usr/bin/env perl

# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Error::Pure qw(err);

# Eval block.
eval {
       err 'Error',
              'Key1', 'Value1',
              'Key2', 'Value2';
};
if ($EVAL_ERROR) {
       print $EVAL_ERROR;
}

# Output.
# TODO