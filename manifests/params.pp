class apt::params {

  # default keyserver.
  $keyserver = 'pgp.mit.edu'

  $manage_preferences = true
  $manage_sourceslist = true

  $ignore_sourceslist = '.placeholder'

  $keyring_package = $::lsbdistid ? {
    Debian => ['debian-keyring', 'debian-archive-keyring'],
    Ubuntu => 'ubuntu-keyring',
  }

  $clean_minutes  = fqdn_rand(60)
  $clean_hours    = '0'
  $clean_monthday = fqdn_rand(28) + 1

}
