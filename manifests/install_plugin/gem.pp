# == fluentd::install_plugin::gem
#
# install a plugin with /usr/lib/fluent/ruby/bin/fluent-gem
#
# Parameters:
#  the name of this ressource reflects the name of the gem
#
#  ensure:      "present"(default), "absent" or a specific gem version, install or uninstall a plugin
#
define fluentd::install_plugin::gem (
    $ensure      = 'present',
    $plugin_name = $name,
) {
    case $::osfamily {
        'debian': {
            $fluent_gem_path = '/usr/lib/fluent/ruby/bin/fluent-gem'
        }
        'redhat': {
            $fluent_gem_path = '/usr/lib64/fluent/ruby/bin/fluent-gem'
        }
        default: {
            fail("${::osfamily} is currently not supported by this module")
        }
    }

    case $ensure {
        absent: {
            exec {
                "uninstall_fluent-${plugin_name}":
                    command => "${fluent_gem_path} uninstall ${plugin_name}",
                    user    => 'root',
                    unless  => "${fluent_gem_path} list --local ${plugin_name} | /bin/grep -qv ${plugin_name}",
                    notify  => Service["${fluentd::service_name}"];
            }
        }
        default: {
            # install a specific version?
            if $ensure == 'present' {
                $version     = ""
                $version_arg = ""
            } elsif $ensure =~ /^\d+(\.\d+)*$/ {
                $version     = $ensure
                $version_arg = " --version ${version}"

                exec { "cleanup_fluent-${plugin_name}":
                    command => "${fluent_gem_path} uninstall ${plugin_name} --all",
                    onlyif  => "test \$(${fluent_gem_path} list --local ${plugin_name} | grep ${plugin_name} | tr ',' '\n' | grep -v ${version} | wc -l) -gt 0",
                    before  => Exec["install_fluent-${plugin_name}"],
                    notify  => Service["${fluentd::service_name}"];
                }
            } else {
                fail("ensure => ${ensure} is currently not supported by this module")
            }

            exec {
                "install_fluent-${plugin_name}":
                    command => "${fluent_gem_path} install ${plugin_name}${version_arg} || true",
                    user    => 'root',
                    unless  => "${fluent_gem_path} list --local ${plugin_name} | /bin/grep -q '${plugin_name}.*${version}'",
                    notify  => Service["${fluentd::service_name}"];
            }
        }
    }
}
