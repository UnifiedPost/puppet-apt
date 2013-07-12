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


      exec { "import gpg key ${name}":
        command => "${thekey} | apt-key add -",
        unless  => "apt-key list | grep -Fe '${name}' | grep -Fvqe 'expired:'",
        before  => Exec['apt-get_update'],
        notify  => Exec['apt-get_update'],
      }
    }

    absent: {
      exec {"apt-key del ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }

    default: {
      fail "Invalid 'ensure' value '${ensure}' for apt::key"
    }

  }
}
