{ ... }: {
  home = {
    #file.".config/vpn/work".source = ./vpn/vpn_work;
    shellAliases = {
      #vpn_work = ''openfortivpn -c ${./vpn/vpn_work}'';
      vpn_work = ''
        netExtender -u gs2 -p "$(pass work/netextender)" -d lan.inteco.ch exchange.inteco.ch:4433 --auto-reconnect'';
    };
  };
}
