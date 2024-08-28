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
          identityFile = "~/.ssh/id_ed25519";
        };
        Pluto = {
          host = "Pluto";
          hostname = "ns1.inteco.ch";
          port = 6699;
          user = "root";
          identityFile = "~/.ssh/id_ed25519";
        };
        Zeus = {
          host = "Zeus";
          hostname = "zeus.inteco.ch";
          port = 6699;
          user = "root";
          identityFile = "~/.ssh/id_ed25519";
        };
        Morpheus = {
          host = "Morpheus";
          hostname = "morpheus.inteco.ch";
          port = 6699;
          user = "inteco";
          extraOptions = { Ciphers = "aes256-cbc"; };
          identityFile = "~/.ssh/id_ed25519";
        };
        SB = {
          host = "SB";
          hostname = "scherer-buehler.ch";
          port = 6699;
          user = "inteco";
          identityFile = "~/.ssh/id_ed25519";
        };
        Ares = {
          host = "Ares";
          hostname = "ares.inteco.ch";
          port = 6699;
          user = "inteco";
          extraOptions = { Ciphers = "aes256-cbc"; };
          identityFile = "~/.ssh/id_ed25519";
        };
        Dionysos = {
          host = "Dionysos";
          hostname = "172.16.200.121";
          port = 22;
          user = "inteco";
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
