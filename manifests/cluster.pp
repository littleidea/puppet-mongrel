define mongrel::cluster($port, $path, $servers = 3, $environment = production, $address = "127.0.0.1") {
    include mongrel
    # We don't start the mongrel cluster service by default;
    # we only start if there is at least one instance.
    realize Service[mongrel_cluster]

    # Create the configuration for mongrel.  Note that this
    # can only configure a single environment to run mongrel.
    $config = "$path/config/mongrel_cluster.yml"
    file { $config:
        content => template("mongrel/mongrel_cluster.erb"),
        notify => Service[mongrel_cluster]
    }

    # Now link it into the cluster configuration directory.
    file { "/etc/mongrel_cluster/${name}_${environment}.yml":
        ensure => $config
    }
}

# $Id$
