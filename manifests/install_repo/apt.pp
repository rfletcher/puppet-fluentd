##apt.pp

# Class: fluentd::install_repo::apt ()
#
#
class fluentd::install_repo::apt (
    $package_name,
) {
    ::apt::key { 'FBA8C0EE63617C5EED695C43254B391D8CACCBF8':
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
