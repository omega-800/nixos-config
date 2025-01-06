{
  lib,
  config,
  net,
  ...
}:
let
  cfg = config.u.net.ssh;
  inherit (net) identityFile;
  inherit (lib)
    mkOption
    types
    mkIf
    listToAttrs
    mapAttrs
    ;
  inherit (lib.omega.cfg) allCfgs;
in
{
  options.u.net.ssh.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable;
  };
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      # addKeysToAgent = "confirm";
      forwardAgent = false;
      hashKnownHosts = true;
      matchBlocks =
        (listToAttrs (
          map (c: {
            name = c.net.hostname;
            value = {
              host = c.net.hostname;
              hostname = "${c.net.hostname}.${c.net.domain}";
              # TODO: read from config
              # port = 6699;
              user = c.usr.username;
              inherit identityFile;
            };
          }) allCfgs
        ))
        // (mapAttrs
          (
            host: v:
            {
              inherit host;
              inherit identityFile;
              identitiesOnly = true;
            }
            // v
          )
          {
            Apollo = {
              hostname = "apollo.inteco.ch";
              port = 6699;
              user = "inteco";
              extraOptions.HostkeyAlgorithms = "ssh-rsa";
            };
            Pluto = {
              hostname = "ns1.inteco.ch";
              port = 6699;
              user = "root";
            };
            Zeus = {
              hostname = "zeus.inteco.ch";
              port = 6699;
              user = "root";
            };
            Morpheus = {
              hostname = "morpheus.inteco.ch";
              port = 6699;
              user = "inteco";
              extraOptions.Ciphers = "aes256-cbc";
            };
            SB = {
              hostname = "scherer-buehler.ch";
              port = 6699;
              user = "inteco";
            };
            Ares = {
              hostname = "ares.inteco.ch";
              port = 6699;
              user = "inteco";
              extraOptions.Ciphers = "aes256-cbc";
            };
            Dionysos = {
              hostname = "172.16.200.121";
              port = 22;
              user = "inteco";
            };
            Wegas = {
              hostname = "172.16.200.40";
              port = 22;
              user = "inteco";
            };
          }
        );
    };
  };
}
