use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new
    (
     module_name         => 'Artemis::Config',
     license             => 'restricted',
     dist_author         => 'OSRC SysInt Team <osrc-sysint@elbe.amd.com>',
     dist_version_from   => 'lib/Artemis/Config.pm',
     build_requires => {
                        'Test::More' => 0,
                       },
     requires => {
                  'Hash::Merge::Simple'         => 0,
                 },
     add_to_cleanup      => [ 'Artemis-Config-*' ],
     create_makefile_pl => 'traditional',
    );

$builder->add_build_element('yml');
$builder->add_build_element('cfg');
$builder->create_build_script();
