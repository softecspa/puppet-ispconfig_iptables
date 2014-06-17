class ispconfig_iptables::vagrant {

  if !defined(Class['iptables']) {
    class {'iptables':
      safe_ssh    => false,
      log         => 'none',
      disableboot => true
    }
  }

  ## VAGRANT SECTION ##########
  #su vagrant apro tutto
  #tutto ciò che proviene da vagrant bridge
  iptables::rule {'vagrant':
      source  => '10.0.2.2',
  }
  # tutto ciò che viene destinata alla eth1 (interfaccia creata con vagrant)
  iptables::rule{'vagrant_eth1':
      destination => $::ipaddress_eth1
  }
  if $::ipaddress_eth2 {
      iptables::rule{'vagrant_eth2':
              destination => $::ipaddress_eth2
                }
  }
  ##################################

}
