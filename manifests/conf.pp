define apt::conf($ensure, $content = false, $source = false) {

  include apt::update

  if $content {
    file {"/etc/apt/apt.conf.d/${name}":
      ensure  => $ensure,
      content => $content,
      before  => Exec['apt::apt-get_update'],
      notify  => Exec['apt::apt-get_update'],
    }
  }

  if $source {
    file {"/etc/apt/apt.conf.d/${name}":
      ensure => $ensure,
      source => $source,
      before  => Exec['apt::apt-get_update'],
      notify => Exec['apt::apt-get_update'],
    }
  }
}
