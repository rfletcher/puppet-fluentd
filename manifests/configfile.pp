# == definition fluentd::configfile
define fluentd::configfile(
  $ensure   = present,
  $content,
  $priority = 50,
) {
  $base_name     = "${name}.conf"
  $conf_name     = "${priority}-${base_name}"
  $conf_dir      = "/etc/td-agent/config.d"
  $conf_path     = "${conf_dir}/${conf_name}"
  $wildcard_path = "${conf_dir}/*-${base_name}"

  # clean up in case of a priority change
  exec { "rm ${wildcard_path}":
    onlyif => "test \$(ls ${wildcard_path} | grep -v ${conf_name} | wc -l) -gt 0",
    before => File[$conf_path],
    notify => Class['fluentd::service'],
  }

  if $ensure == 'absent' {
    file { $conf_path:
      ensure  => $ensure,
      notify  => Class['fluentd::service'],
    }
  } else {
    if ! defined(Exec["mkdir -p ${conf_dir}"]) {
      exec { "mkdir -p ${conf_dir}":
        creates => $config_dir,
      }
    }

    file { $conf_path:
      ensure  => $ensure,
      content => $content,
      owner   => 'td-agent',
      group   => 'td-agent',
      mode    => '0644',
      before  => Class['fluentd::packages'],
      require => Exec["mkdir -p ${conf_dir}"],
      notify  => Class['fluentd::service'],
    }
  }
}
