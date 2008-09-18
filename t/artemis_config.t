#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

plan tests => 12;

use Artemis::Config;

is(Artemis::Config->subconfig->{test_value},              'test',         "[context: test] base configs");
is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: test] base config");
is(Artemis::Config->subconfig->{test}{files}{log4perl_cfg}, 'log4perl_test.cfg', "[context: test] log4perl config file");
like(Artemis::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Artemis/Config/log4perl_test.cfg}, "[context: test] log4perl config file fullpath");
is_deeply(Artemis::Config->subconfig->{patchopt}, [ '-p1' ], "[context: test] patchopt");

{
        local $ENV{ARTEMIS_LIVE} = 1;
        Artemis::Config->_switch_context();
        is(Artemis::Config->subconfig->{test_value},              'live',         "[context: live] Subconfig");
        is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: live] base config");
        like(Artemis::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Artemis/Config/log4perl.cfg}, "[context: live] log4perl config file fullpath");
}
Artemis::Config->_switch_context();

isnt ($ENV{ARTEMIS_LIVE}, 1, "ARTEMIS_LIVE set back");

{
        local $ENV{HARNESS_ACTIVE} = 0;
        Artemis::Config->_switch_context();
        is(Artemis::Config->subconfig->{test_value}, 'development', "[context: development] Subconfig");
        is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: development] base config");
}

Artemis::Config->_switch_context();
isnt ($ENV{HARNESS_ACTIVE}, 0, "HARNESS_ACTIVE set back");

