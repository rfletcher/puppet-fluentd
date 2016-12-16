# == definition fluentd::filter
define fluentd::filter (
  $ensure   = present,
  $config   = {},
  $priority = 25,
  $pattern,
) {
  fluentd::configfile { "filter-${name}":
    ensure   => $ensure,
    content  => template( 'fluentd/filter.erb' ),
    priority => $priority,
  }
}
