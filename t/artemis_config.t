#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

plan tests => 10;

use Artemis::Config;


# test

local $ENV{ARTEMIS_DEVELOPMENT} = 1; # like in typical development environment

is(Artemis::Config->subconfig->{test_value},              'test',         "[context: test] base configs");
is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: test] base config");
is(Artemis::Config->subconfig->{test}{files}{log4perl_cfg}, 'log4perl_test.cfg', "[context: test] log4perl config file");
like(Artemis::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Artemis/Config/log4perl_test.cfg}, "[context: test] log4perl config file fullpath");

{
        # live

        local $ENV{ARTEMIS_DEVELOPMENT} = 0;
        local $ENV{HARNESS_ACTIVE} = 0;

        Artemis::Config->_switch_context();
        is(Artemis::Config->subconfig->{test_value},              'live',         "[context: live] Subconfig");
        is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: live] base config");
        like(Artemis::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Artemis/Config/log4perl.cfg}, "[context: live] log4perl config file fullpath");
}

{
        #development

        local $ENV{HARNESS_ACTIVE} = 0;
        local $ENV{ARTEMIS_DEVELOPMENT} = 1;

        Artemis::Config->_switch_context();
        is(Artemis::Config->subconfig->{test_value}, 'development', "[context: development] Subconfig");
        is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: development] base config");
}

Artemis::Config->_switch_context();
isnt ($ENV{HARNESS_ACTIVE}, 0, "HARNESS_ACTIVE set back");

