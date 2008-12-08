#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

plan tests => 1;

use Artemis::PRC::Proxy;


my $config = {};
my $proxy = Artemis::PRC::Proxy->new($config);

