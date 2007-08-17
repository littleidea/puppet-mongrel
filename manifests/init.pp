class mongrel {
    include ruby

	# Stupid gems can't handle this
	#package { mongrel: ensure => installed, provider => gem }
    rubygems::brokengem { mongrel: ensure => installed, source => "http://rubyforge.org/frs/download.php/16719/mongrel-1.0.1.gem", require => Package[fastthread] }
    rubygems::brokengem { fastthread: ensure => installed, source => "http://rubyforge.org/frs/download.php/18636/fastthread-1.0.gem", require => Package[ruby-devel] }
    package { [daemons, gem_plugin, cgi_multipart_eof_fix, mongrel_cluster]: ensure => installed, provider => gem, before => Package[mongrel] }

    file { "/etc/init.d/mongrel_cluster":
        source => "puppet:///mongrel/mongrel_cluster",
        mode => 755
    }

    file { ["/etc/mongrel_cluster", "/var/run/mongrel_cluster"]:
        ensure => directory
    }

    @service { mongrel_cluster:
        ensure => running,
        enable => true,
        subscribe => File["/etc/init.d/mongrel_cluster"]
    }
}

# $Id$
