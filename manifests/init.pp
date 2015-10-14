class ispconfig_iptables (
  $disableboot  = false,
  $enable_v6    = false,
){

  class {'iptables':
    safe_ssh    => false,
    log         => 'none',
    disableboot => $disableboot,
    enable_v6   => $enable_v6
  }

  # da reti Softec
  $from_softec_ports = {
    'ssh'       => { port => '22'          },
    'ispconfig' => { port => '81'          },
    'ftp'       => { port => '21'          },
    'ftp-passv' => { port => '49100:50000' },
  }

  create_resources ('iptables::rule',$from_softec_ports,{
    'source' => split($::subnet_softec,' ')
  })

  # da VLAN115 per BackupPC e repliche MySQL
  $from_bologna_vlan115 = {
    'backuppc_ssh'    => { port => '22'   },
    'barattolo_mysql' => { port => '3306' },
  }

  create_resources ('iptables::rule',$from_bologna_vlan115,{
    'source' => '77.238.6.144/28'
  })

  # dal ServerContalo: da dismettere
  iptables::rule {'contalo_logs':
    source => '77.238.6.23',
    port   => '8089'
  }

  # dal Nagios
  $from_nagios_ports =  {
    'nagios_ssh'        => { port => '22'   },
    'nagios_nrpe'       => { port => '5666' },
    'nagios_ispconfig'  => { port => '81'   },
    'nagios_ftp'        => { port => '21'   },
    'nagios_imap'       => { port => '143'  },
    'nagios_pop'        => { port => '110'  },
  }

  create_resources('iptables::rule',$from_nagios_ports, {
    'source' => $::nagios_ip
  })

  # aperte al mondo
  $from_world_ports = {
    'http'  => { port => '80'  },
    'https' => { port => '443' },
    'smtp'  => { port => '25'  },
    'imaps' => { port => '993' },
    'pops'  => { port => '995' },
  }

  create_resources('iptables::rule',$from_world_ports,{
    'enable_v6' => $enable_v6
  })

  # da mugolo01.softecpa.it PowerDns
  $from_mugolo01 = {
    'mugolo01_dns_udp'              => { port => '53', protocol => 'udp', },
    'mugolo01_dns_tcp'              => { port => '53', protocol => 'tcp', },
    'mugolo01_dns_udp_unprivileged' => {
        port => '1024:65536',
        protocol => 'udp',
    },
    'mugolo01_dns_tcp_unprivileged' => {
      port => '1024:65536',
      protocol => 'tcp',
    },
  }

  create_resources ('iptables::rule',$from_mugolo01,{
    'source' => '77.238.6.58'
  })

}
