##apt.pp

# Class: fluentd::install_repo::apt ()
#
#
class fluentd::install_repo::apt () {
    ::apt::key { 'C901622B5EC4AF820C38AB861093DB45A12E206F':
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
