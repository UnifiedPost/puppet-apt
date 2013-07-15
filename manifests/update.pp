class apt::update {

  exec {'apt::apt-get_update':
    command     => 'apt-get update',
    refreshonly => true,
    path        => ['/usr/bin','/bin'],
  }

}
