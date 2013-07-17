class apt (
  $manage_preferences = $::apt::params::manage_preferences,
  $manage_sourceslist = $::apt::params::manage_sourceslist,
  $ignore_sourceslist = $::apt::params::ignore_sourceslist,
  $keyring_package    = $::apt::params::keyring_package,
  $keyserver          = $::apt::params::keyserver,
  $clean_minutes      = $::apt::params::clean_minutes,
  $clean_hours        = $::apt::params::clean_hours,
  $clean_monthday     = $::apt::params::monthday,
) inherits apt::params {

  include apt::update

  Package {
    require => Exec['apt::apt-get_update']
  }

  # apt support preferences.d since version >= 0.7.22
  if versioncmp($::apt_version, '0.7.22') >= 0 {
    file {'/etc/apt/preferences':
      ensure => absent,
    }

    file {'/etc/apt/preferences.d':
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0755',
      recurse => $manage_preferences,
      purge   => $manage_preferences,
      force   => $manage_preferences,
    }
  }

  package {$keyring_package:
    ensure => present,
  }

  # ensure only files managed by puppet be present in this directory.
  file {'/etc/apt/sources.list.d':
    ensure  => directory,
    source  => 'puppet:///modules/apt/empty/',
    recurse => $manage_sourceslist,
    purge   => $manage_sourceslist,
    force   => $manage_sourceslist,
    ignore  => $ignore_sourceslist,
  }

  apt::conf {'10periodic':
    ensure => present,
    source => 'puppet:///modules/apt/10periodic',
  }

  # apt support preferences.d since version >= 0.7.22
  if versioncmp($::apt_version, '0.7.22') < 0 {
    concat {'/etc/apt/preferences':
      owner   => root,
      group   => root,
      mode    => '0644',
      force   => true,
      before  => Exec['apt-get_update'],
      notify  => Exec['apt-get_update'],
    }
  }
}
