include apt

class cassandra {
  apt::source { "cassandra":
    keys        => [ "8D77295D", "2B5C1B00" ],
    ensure      => present,
    before      => Package["cassandra"],
  }

  package { 'cassandra':
    ensure      => present,
  }

  user { 'cassandra':
    ensure      => present,
    home        => "/var/lib/cassandra",
  }

  service { 'cassandra':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => Package['cassandra'],
  }

  define cluster_node (
    $cluster_name = "Cassandra Cluster",
    $data_file_directory = "/var/lib/cassandra/data",
    $commitlog_directory = "/var/lib/cassandra/commitlog",
    $saved_caches = "/var/lib/cassandra/saved_caches",
    $max_heap_size = "4G", 
    $heap_newsize = "800M",
    $initial_token, 
    $seeds) {

    file { '/etc/cassandra/cassandra.yaml':
      ensure    => file,
      content   => template("cassandra/cassandra.yaml.erb"),
      owner     => root,
      group     => root,
      mode      => 644,
      require   => Package["cassandra"],
    }

    file { '/etc/cassandra/cassandra-env.sh':
      ensure    => file,
      content   => template("cassandra/cassandra-env.sh.erb"),
      owner     => root,
      group     => root,
      mode      => 644,
      require   => Package["cassandra"],
    }
  }
}
