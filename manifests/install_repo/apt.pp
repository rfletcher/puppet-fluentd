##apt.pp

# Class: fluentd::install_repo::apt ()
#
#
class fluentd::install_repo::apt () {
    ::apt::key { 'treasure-data':
        source => 'https://packages.treasuredata.com/GPG-KEY-td-agent',
    } ->

    ::apt::source { 'treasure-data':
        include  => { 'src' => false },
        location => "http://packages.treasuredata.com/2/ubuntu/${::lsbdistcodename}",
        release  => "${::lsbdistcodename}",
        repos    => "contrib",
        notify   => Class['apt::update'],
    }
}
