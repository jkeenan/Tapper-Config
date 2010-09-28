#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

BEGIN{ 
        $ENV{ARTEMIS_CONFIG_FILE} = 't/additional_files/artemis.cfg'; 
        $ENV{ARTEMIS_DEVELOPMENT} = 1;
}

use Artemis::Config;
is(Artemis::Config->subconfig->{paths}{output_dir}, '/merge/test/succeeded/',         "config merged");


done_testing();
