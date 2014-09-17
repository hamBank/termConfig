resources { "firewall":
  purge => true
}
Firewall {
  before  => Class['my_fw::post'],
  require => Class['my_fw::pre'],
}
class { ['my_fw::pre', 'my_fw::post']: }
class { 'firewall': }

class { 'jenkins':
	configure_firewall => false,
}

node 'puppet' {
	include jenkins
	firewall { '100 allow http and https access':
    port   => [8080, 443],
    proto  => tcp,
    action => accept,
  }
}
