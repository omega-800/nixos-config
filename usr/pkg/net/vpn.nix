{ ... }: {
  home ={
    #file.".config/vpn/work".source = ./vpn/vpn_work;
    shellAliases = {
      vpn_work = ''openfortivpn -c ${./vpn/vpn_work}'';
    };
  };
}
