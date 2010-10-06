use strict;
use warnings;

use inc::Module::Install;

name     'Artemis-Cmd';
all_from 'lib/Artemis/Config.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';

build_requires 'Test::More'         => 0;
build_requires 'Test::Perl::Critic' => 0;
build_requires 'Artemis::Test'      => '2.010005';
build_requires 'File::Slurp'        => 0;

requires 'Hash::Merge::Simple' => 0;
requires 'File::ShareDir'      => 0;
requires 'perl'                => '5.010';
requires 'YAML::Syck'          => 0;

WriteAll;

