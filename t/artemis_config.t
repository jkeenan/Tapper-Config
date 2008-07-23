#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

plan tests => 20;

use Artemis::Config;

is(Artemis::Config->subconfig->{test_value},              'test',         "[context: test] base configs");
is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: test] base config");
is(Artemis::Config->subconfig->{paths}{nfsroot}, '165.204.85.14:/vol/osrc_data/nfsroot/installation_base/', "[context: test] paths.nfsroot");
is(Artemis::Config->subconfig->{paths}{build_conf_path}, '/usr/share/artemis/test_data/config/', "[context: test] build_conf_path");
is(Artemis::Config->subconfig->{paths}{build_dir}, '/usr/share/artemis/build/', "[context: test] build_dir");
is(Artemis::Config->subconfig->{paths}{grubpath}, '/usr/share/artemis/test_data/artemis_conf/', "[context: test] grubpath");
is(Artemis::Config->subconfig->{paths}{logfilepath}, '/usr/share/artemis/test_data/output/', "[context: test] logfilepath");
is(Artemis::Config->subconfig->{paths}{testprog_path}, '/usr/share/artemis/testprogram/', "[context: test] testprog_path");
is(Artemis::Config->subconfig->{test}{files}{log4perl_cfg}, 'log4perl_test.cfg', "[context: test] log4perl config file");
like(Artemis::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Artemis/Config/log4perl_test.cfg}, "[context: test] log4perl config file fullpath");
is_deeply(Artemis::Config->subconfig->{patchopt}, [ '-p1' ], "[context: test] patchopt");

{
        local $ENV{ARTEMIS_LIVE} = 1;
        Artemis::Config->_switch_context();
        is(Artemis::Config->subconfig->{test_value},              'live',         "[context: live] Subconfig");
        is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: live] base config");
        is(Artemis::Config->subconfig->{paths}{nfsroot}, '165.204.85.14:/vol/osrc_data/nfsroot/installation_base/', "[context: live] paths.nfsroot");
        like(Artemis::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Artemis/Config/log4perl.cfg}, "[context: live] log4perl config file fullpath");
}
Artemis::Config->_switch_context();

isnt ($ENV{ARTEMIS_LIVE}, 1, "ARTEMIS_LIVE set back");

{
        local $ENV{HARNESS_ACTIVE} = 0;
        Artemis::Config->_switch_context();
        is(Artemis::Config->subconfig->{test_value}, 'development', "[context: development] Subconfig");
        is(Artemis::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: development] base config");
        is(Artemis::Config->subconfig->{paths}{nfsroot}, '165.204.85.14:/vol/osrc_data/nfsroot/installation_base_devel/', "[context: development] paths.nfsroot");
}

Artemis::Config->_switch_context();
isnt ($ENV{HARNESS_ACTIVE}, 0, "HARNESS_ACTIVE set back");

