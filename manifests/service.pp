
class icinga::service {

  case $lsbdistdescription {
    ## some tricky logic to use systemd on fedora 17+
    /Fedora release (.+)/: {
      if versioncmp($1,"17") >= 0 {
        $servicename = 'icinga.service'
        $provider = 'systemd'
      }
    }
    default: {
      $servicename = 'icinga'
      $provider = undef
    }
  }
  service { 'icinga':
    name => $servicename,
    provider => $provider,
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    restart => $provider ? { default => '/etc/init.d/icinga reload', 'systemd' => "systemctl reload ${servicename}"},
    require => Class[icinga::idoservice],
  }

}

