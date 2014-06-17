class ispconfig_iptables (
  $disableboot  = false
){

  class {'iptables':
    safe_ssh    => false,
    log         => 'none',
    disableboot => $disableboot
  }

######## SOLO DA RETI SOFTEC ################
$from_softec_ports = {  'ssh'       => { port => '22'},
                        'ispconfig' => { port => '81'},
                        'ftp'       => { port => '21'},
                        'ftp-passv' => { port => '49100:50000'}
                     }
create_resources ('iptables::rule',$from_softec_ports,{'source' => split($::subnet_softec,' ')})

######### SOLO DA PARTICOLARI HOST ##########
iptables::rule {'contalo_logs':
  source  => '77.238.6.23',
  port    => '8089'
}
$from_nagios_ports =  { 'nagios_ssh'        => { port => '22'},
                        'nagios_nrpe'       => { port => '5666'},
                        'nagios_ispconfig'  => { port => '81'},
                        'nagios_ftp'        => { port => '21'},
                        'nagios_imap'       => { port => '143'},
                        'nagios_imaps'      => { port => '993'},
                        'nagios_pop'        => { port => '110'},
                        'nagios_pops'       => { port => '995'},

                      }
create_resources('iptables::rule',$from_nagios_ports, {'source' => $::nagios_ip})

######### AL MONDO ##########################
$from_world_ports = { 'http'  => {'port' => '80'},
                      'https' => {'port' => '443'},
                      'smtp'  => {'port' => '25'},
                    }
create_resources('iptables::rule',$from_world_ports)

}
