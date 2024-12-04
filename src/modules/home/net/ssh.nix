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
        // {
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
            extraOptions.Ciphers = "aes256-cbc";
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
            extraOptions = {
              Ciphers = "aes256-cbc";
            };
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
