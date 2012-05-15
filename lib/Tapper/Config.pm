package Tapper::Config;
# ABSTRACT: Tapper - Context sensitive configuration hub for all Tapper libs

use 5.010;

use strict;
use warnings;

use YAML::Syck;
use File::Slurp         'slurp';
use File::ShareDir      'module_file';
use Hash::Merge::Simple 'merge';
use File::ShareDir 'module_file';

=head1 SYNOPSIS

 use Tapper::Config;
 say Tapper::Config->subconfig->{test_value};
 say Tapper::Config->subconfig->{paths}{build_conf_path};

=cut

# --- The configuration file is lib/auto/Tapper/Config/tapper.yml ---
{
        # closure to forbid direct access to the config hash
        my $Config;


=head2 default_merge

Merges default values from /etc/tapper into the config. This allows to
overwrite values given from the config provided with the module. It
searches for config in the following places.
* filename given in $ENV{TAPPER_CONFIG_FILE}
* $ENV{HOME}/.tapper.cfg
* /etc/tapper.cfg

If $ENV{TAPPER_CONFIG_FILE} exists it will be used no mather if it
contains an existing file. If this key does not exists the first file
found from the list of remaining alternatives is used.

@param hash ref - config

@return hash ref - merged config

=cut

        sub default_merge
        {
                my ($config) = @_;
                my $new_config;
                no warnings 'uninitialized'; # $ENV{HOME} can be undef
                if (exists $ENV{TAPPER_CONFIG_FILE}) {
                        my $env_config_file = $ENV{TAPPER_CONFIG_FILE} || "";
                        die "Config file '$env_config_file' does not exist.\n" unless -r $env_config_file;
                        eval {
                                $new_config = LoadFile($env_config_file);
                        };
                        die "Can not load config file '$env_config_file': $@\n" if $@;
                } elsif ( -e "$ENV{HOME}/.tapper.cfg" ) {
                                $new_config = LoadFile("$ENV{HOME}/.tapper.cfg");
                } elsif ( -e "/etc/tapper.cfg" ) {
                        $new_config = LoadFile("/etc/tapper.cfg");
                } else {
                        return $config;
                }
                $config = merge($config, $new_config);
                return $config;
        }


        sub _getenv
        {
                return
                    $ENV{HARNESS_ACTIVE} ? 'test'
                        : $ENV{TAPPER_DEVELOPMENT} ? 'development'
                            : 'live';
        }


        # TODO: automatically recognize context switch
        sub _switch_context
        {
                shift if @_ && $_[0] && $_[0] eq 'Tapper::Config'; # throw away class if called as method

                my $env = shift // _getenv();

                return unless $env =~ /^test|live|development$/;

                my $yaml = slurp module_file('Tapper::Config', 'tapper.yml');
                $Config  = Load($yaml);
                $Config  = default_merge($Config);

                $Config  = merge( $Config, $Config->{$env} );
                $Config  = _prepare_special_entries( $Config );
        }

        sub _prepare_special_entries {
                my ($Config) = @_;

                if (not $Config->{files}{log4perl_cfg} =~ m,^/,) {
                        $Config->{files}{log4perl_cfg} = module_file('Tapper::Config', $Config->{files}{log4perl_cfg});
                }
                return $Config;
        }

        sub subconfig { $Config }

}

BEGIN { _switch_context() }

1;

