define apt::conf($ensure, $content = false, $source = false) {

  include apt::update

  if $content {
    file {"/etc/apt/apt.conf.d/${name}":
      ensure  => $ensure,
      content => $content,
      owner   => 'root',
      group   => 'root',
      before  => Exec['apt::apt-get_update'],
      notify  => Exec['apt::apt-get_update'],
    }
  }

  if $source {
    file {"/etc/apt/apt.conf.d/${name}":
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      source => $source,
      before => Exec['apt::apt-get_update'],
      notify => Exec['apt::apt-get_update'],
    }
  }
}
