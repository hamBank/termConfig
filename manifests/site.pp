resources { "firewall":
  purge => true
}
Firewall {
  before  => Class['my_fw::post'],
  require => Class['my_fw::pre'],
}
class { ['my_fw::pre', 'my_fw::post']: }
class { 'firewall': }


node 'puppet' {
	class { 'jenkins':
		configure_firewall => false,
	}
	firewall { '100 allow http and https access':
    port   => [8080, 443],
    proto  => tcp,
    action => accept,
  }
class { 'tomcat': 
	user => 'tomcat',
	manage_user => true,
}

tomcat::instance { 'tomcat8':
  catalina_base => '/opt/apache-tomcat/tomcat8',
  source_url    => 'http://mirror.reverse.net/pub/apache/tomcat/tomcat-8/v8.0.12/bin/apache-tomcat-8.0.12.tar.gz'
}
tomcat::service { 'default':
  catalina_base => '/opt/apache-tomcat/tomcat8',
  service_name => 'tomcat8',
  use_init => false,
  service_ensure => 'running',
}

tomcat::instance { 'tomcat6':
  source_url    => 'http://apache.petsads.us/tomcat/tomcat-6/v6.0.41/bin/apache-tomcat-6.0.41.tar.gz',
  catalina_base => '/opt/apache-tomcat/tomcat6',
}
tomcat::config::server { 'tomcat8':
  catalina_base => '/opt/apache-tomcat/tomcat8',
  port          => '9105',
}
tomcat::config::server::connector { 'tomcat8-http':
  catalina_base         => '/opt/apache-tomcat/tomcat8',
  port                  => '9180',
  protocol              => 'HTTP/1.1',
  additional_attributes => {
    'redirectPort' => '9543'
  },
}
tomcat::config::server::connector { 'tomcat8-ajp':
  catalina_base         => '/opt/apache-tomcat/tomcat8',
  port                  => '9109',
  protocol              => 'AJP/1.3',
  additional_attributes => {
    'redirectPort' => '9543'
  },
}
tomcat::config::server { 'tomcat6':
  catalina_base => '/opt/apache-tomcat/tomcat6',
  port          => '8105',
}
tomcat::config::server::connector { 'tomcat6-http':
  catalina_base         => '/opt/apache-tomcat/tomcat6',
  port                  => '8180',
  protocol              => 'HTTP/1.1',
  additional_attributes => {
    'redirectPort' => '8543'
  },
}
tomcat::config::server::connector { 'tomcat6-ajp':
  catalina_base         => '/opt/apache-tomcat/tomcat6',
  port                  => '8109',
  protocol              => 'AJP/1.3',
  additional_attributes => {
    'redirectPort' => '8543'
  },
}
tomcat::service { 'tomcat6':
  catalina_base => '/opt/apache-tomcat/tomcat6',
  service_name => 'tomcat6',
  use_init => false,
  service_ensure => 'running',
}
tomcat::war { 'sample.war':
        catalina_base => '/opt/apache-tomcat/tomcat8',
        war_source => '/tmp/foo.war',
      }
}
