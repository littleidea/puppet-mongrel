# Copyright (c) 2008, Luke Kanies, luke@madstop.com
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
