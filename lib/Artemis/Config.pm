package Artemis::Config;

use 5.010;

use strict;
use warnings;

use YAML::Syck;
use File::Slurp         'slurp';
use File::ShareDir      'module_file';
use Hash::Merge::Simple 'merge';
use File::ShareDir 'module_file';

=head1 NAME

Artemis::Config - Offer configuration for all parts running on Artemis host

=head1 VERSION

Version 0.01

=cut

our $VERSION = '2.010022';

=head1 SYNOPSIS

 use Artemis::Config;
 say Artemis::Config->subconfig->{test_value};
 say Artemis::Config->subconfig->{paths}{build_conf_path};


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive


=cut

# --- The configuration file is lib/auto/Artemis/Config/artemis.yml ---

{
        # closure to forbid direct access to the config hash

        my $Config;

        sub _getenv
        {
                # Migration help during switch from default-devel to default-live
                die "Use of ENV{ARTEMIS_LIVE} is deprecated, use ARTEMIS_DEVELOPMENT=1" if ($ENV{ARTEMIS_LIVE} and not $ENV{HARNESS_ACTIVE});

                return
                    $ENV{HARNESS_ACTIVE} ? 'test'
                        : $ENV{ARTEMIS_DEVELOPMENT} ? 'development'
                            : 'live';
        }

        # TODO: automatically recognize context switch
        sub _switch_context
        {
                shift if @_ && $_[0] && $_[0] eq 'Artemis::Config'; # throw away class if called as method

                my $env = shift // _getenv();

                return unless $env =~ /^test|live|development$/;

                my $yaml = slurp module_file('Artemis::Config', 'artemis.yml');
                $Config  = Load($yaml);
                $Config  = merge( $Config, $Config->{$env} );
                $Config  = _prepare_special_entries( $Config );
        }

        sub _prepare_special_entries {
                my ($Config) = @_;

                $Config->{files}{log4perl_cfg} = module_file('Artemis::Config', $Config->{files}{log4perl_cfg});
                return $Config;
        }

        sub subconfig { $Config }

}

BEGIN { _switch_context() }

1;

