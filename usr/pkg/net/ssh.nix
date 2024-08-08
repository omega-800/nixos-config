{ lib, config, ... }:
with lib;
let cfg = config.u.net.ssh;
in {
  options.u.net.ssh.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable;
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      hashKnownHosts = true;
      matchBlocks = {
        Apollo = {
          host = "Apollo";
          hostname = "apollo.inteco.ch";
          port = 6699;
          user = "inteco";
        };
        Pluto = {
          host = "Pluto";
          hostname = "ns1.inteco.ch";
          port = 6699;
          user = "root";
        };
        Zeus = {
          host = "Zeus";
          hostname = "zeus.inteco.ch";
          port = 6699;
          user = "root";
        };
        Morpheus = {
          host = "Morpheus";
          hostname = "morpheus.inteco.ch";
          port = 6699;
          user = "inteco";
          extraOptions = { Ciphers = "aes256-cbc"; };
        };
        SB = {
          host = "SB";
          hostname = "scherer-buehler.ch";
          port = 6699;
          user = "inteco";
        };
        Ares = {
          host = "Ares";
          hostname = "ares.inteco.ch";
          port = 6699;
          user = "inteco";
          extraOptions = { Ciphers = "aes256-cbc"; };
        };
        Dionysos = {
          host = "Dionysos";
          hostname = "172.16.200.121";
          port = 22;
          user = "inteco";
        };
      };
    };
  };
}
