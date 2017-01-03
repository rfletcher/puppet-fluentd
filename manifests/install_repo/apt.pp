##apt.pp

# Class: fluentd::install_repo::apt ()
#
#
class fluentd::install_repo::apt (
  $package_name,
) {
    ::apt::key { 'BEE682289B2217F45AF4CC3F901F9177AB97ACBE':
        source => 'https://packages.treasuredata.com/GPG-KEY-td-agent',
    } ->

    ::apt::source { 'treasure-data':
        include  => { 'src' => false },
        location => "http://packages.treasuredata.com/2/ubuntu/${::lsbdistcodename}",
        release  => "${::lsbdistcodename}",
        repos    => "contrib",
        notify   => Class['::apt::update'],
    }

    Class['::apt::update'] -> Package[$package_name]
}
