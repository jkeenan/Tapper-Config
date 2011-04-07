use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Config';
all_from 'lib/Tapper/Config.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'freebsd';

build_requires 'Test::More'         => 0;
build_requires 'Test::Perl::Critic' => 0;
build_requires 'Tapper::Test' => "3.000010";
build_requires 'File::Slurp'        => 0;

author_requires 'Module::Install::WriteAll';

requires 'Hash::Merge::Simple' => 0;
requires 'File::Slurp'         => 0;
requires 'File::ShareDir'      => 0;
requires 'perl'                => '5.010';
requires 'YAML::Syck'          => "1.17";

repository 'git://github.com/amd/Tapper-Config.git';
bugtracker 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Config';

WriteAll;

