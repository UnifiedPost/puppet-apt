define apt::sources_list (
  $ensure       = present,
  $source       = false,
  $content      = false,
  $target       = "/etc/apt/sources.list.d/${name}.list",
  $uri          = undef,
  $components   = undef,
  $deb_src      = false,
  $distribution = $::lsbdistcodename,
  $key          = undef,
  $keyserver    = undef,
  $keysource    = undef,
  $keycontent   = undef,
) {

  include apt::update

  if $key {
    if ! defined(Apt::Key[$key]) {
      apt::key { $key:
        ensure => $ensure
      }
      if $keyserver  { Apt::Key[$key] { keyserver => $keyserver  } }
      if $keysource  { Apt::Key[$key] { source    => $keysource  } }
      if $keycontent { Apt::Key[$key] { content   => $keycontent } }
    }
  }

  if $source {
    file {$target:
      ensure  => $ensure,
      source  => $source,
      before  => Exec['apt::apt-get_update'],
      notify  => Exec['apt::apt-get_update'],
    }
  } elsif $content {
    file {$target:
      ensure  => $ensure,
      content => $content,
      before  => Exec['apt::apt-get_update'],
      notify  => Exec['apt::apt-get_update'],
    }
  }
  else {
    if $uri == undef or $components == undef {
      fail('uri and components are required parameters when not using source or content.')
    }

    file {$target:
      ensure  => $ensure,
      content => template('apt/sources.list.erb'),
      before  => Exec['apt::apt-get_update'],
      notify  => Exec['apt::apt-get_update'],
    }
  }

}
