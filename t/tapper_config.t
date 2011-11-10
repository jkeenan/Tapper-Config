#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

plan tests => 11;

use Tapper::Config;


local $ENV{TAPPER_CONFIG_FILE}="lib/auto/Tapper/Config/tapper.yml";

# test
is(Tapper::Config->subconfig->{test_value},              'test',         "[context: test] base configs");
is(Tapper::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: test] base config");
is(Tapper::Config->subconfig->{test}{files}{log4perl_cfg}, 'log4perl_test.cfg', "[context: test] log4perl config file");
like(Tapper::Config->subconfig->{files}{log4perl_cfg}, qr{auto/Tapper/Config/log4perl_test.cfg}, "[context: test] log4perl config file fullpath");

{
        # live

        local $ENV{TAPPER_DEVELOPMENT} = 0;
        local $ENV{HARNESS_ACTIVE} = 0;

        my $expected_grub = '
serial --unit=0 --speed=115200
terminal serial

default 0
timeout 2
title Test
     tftpserver $TAPPER_TFTPSERVER
     kernel $TAPPER_KERNEL earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 root=/dev/nfs ro ip=dhcp nfsroot=$TAPPER_NFSROOT $TAPPER_OPTIONS
';

        Tapper::Config->_switch_context();
        is(Tapper::Config->subconfig->{test_value},              'live',         "[context: live] Subconfig");
        is(Tapper::Config->subconfig->{test_value_only_in_base}, 'only_in_base', "[context: live] base config");
        is(Tapper::Config->subconfig->{mcp}{installer}{default_grub}, $expected_grub, "[context: live] installer default grub");
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

