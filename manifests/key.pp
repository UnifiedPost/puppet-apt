define apt::key (
  $keyserver = $::apt::keyserver,
  $ensure  = present,
  $source  = '',
  $content = ''
) {

  include apt

  case $ensure {

    present: {
      if $content == '' {
        if $source == '' {
          $thekey = "gpg --keyserver ${keyserver} --recv-key '${name}' && gpg --export --armor '${name}'"
        }
        else {
          $thekey = "wget -O - '${source}'"
        }
      }
      else {
        $thekey = "echo '${content}'"
      }


      exec { "apt::key-import gpg key ${name}":
        command => "${thekey} | apt-key add -",
        unless  => "apt-key list | grep -Fe '${name}' | grep -Fvqe 'expired:'",
        before  => Exec['apt-get_update'],
        notify  => Exec['apt-get_update'],
        path    => ['/usr/bin','/bin'],
      }
    }

    absent: {
      # this doesnt actually do anything....
      exec {"apt::key-del gpg key ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
        path   => ['/usr/bin','/bin'],
      }
    }

    default: {
      fail "Invalid 'ensure' value '${ensure}' for apt::key"
    }

  }
}
