#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

plan tests => 10;

use Tapper::Config;


# test
is(Tapper::Config->subconfig->{test_value},              'test',         "[context: test] base configs");
is(Tapper::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: test] base config");
is(Tapper::Config->subconfig->{test}{files}{log4perl_cfg}, 'log4perl_test.cfg', "[context: test] log4perl config file");
like(Tapper::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Tapper/Config/log4perl_test.cfg}, "[context: test] log4perl config file fullpath");

{
        # live

        local $ENV{TAPPER_DEVELOPMENT} = 0;
        local $ENV{HARNESS_ACTIVE} = 0;

        Tapper::Config->_switch_context();
        is(Tapper::Config->subconfig->{test_value},              'live',         "[context: live] Subconfig");
        is(Tapper::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: live] base config");
        like(Tapper::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Tapper/Config/log4perl.cfg}, "[context: live] log4perl config file fullpath");
}

{
        #development

        local $ENV{HARNESS_ACTIVE} = 0;
        local $ENV{TAPPER_DEVELOPMENT} = 1;

        Tapper::Config->_switch_context();
        is(Tapper::Config->subconfig->{test_value}, 'development', "[context: development] Subconfig");
        is(Tapper::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: development] base config");
}

Tapper::Config->_switch_context();
isnt ($ENV{HARNESS_ACTIVE}, 0, "HARNESS_ACTIVE set back");

