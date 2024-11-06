{ lib, config, sys, ... }:
with lib;
let
  cfg = config.u.net.ssh;
  inherit (sys) identityFile;
in
{
  options.u.net.ssh.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable;
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = false;
      hashKnownHosts = true;
      matchBlocks = {
        Apollo = {
          host = "Apollo";
          hostname = "apollo.inteco.ch";
          port = 6699;
          user = "inteco";
          inherit identityFile;
        };
        Pluto = {
          host = "Pluto";
          hostname = "ns1.inteco.ch";
          port = 6699;
          user = "root";
          inherit identityFile;
        };
        Zeus = {
          host = "Zeus";
          hostname = "zeus.inteco.ch";
          port = 6699;
          user = "root";
          inherit identityFile;
        };
        Morpheus = {
          host = "Morpheus";
          hostname = "morpheus.inteco.ch";
          port = 6699;
          user = "inteco";
          extraOptions = { Ciphers = "aes256-cbc"; };
          inherit identityFile;
        };
        SB = {
          host = "SB";
          hostname = "scherer-buehler.ch";
          port = 6699;
          user = "inteco";
          inherit identityFile;
        };
        Ares = {
          host = "Ares";
          hostname = "ares.inteco.ch";
          port = 6699;
          user = "inteco";
          extraOptions = { Ciphers = "aes256-cbc"; };
          inherit identityFile;
        };
        Dionysos = {
          host = "Dionysos";
          hostname = "172.16.200.121";
          port = 22;
          user = "inteco";
          inherit identityFile;
        };
        Wegas = {
          host = "Wegas";
          hostname = "172.16.200.40";
          port = 22;
          user = "inteco";
          inherit identityFile;
        };
      };
    };
  };
}
