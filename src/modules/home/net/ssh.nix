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
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          # addKeysToAgent = "confirm";
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = true;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
      }
      // (listToAttrs (
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
          oss-gl = {
            hostname = "gitlab.com";
            identityFile = "~/.ssh/gitlab";
          };
          AADL = {
            hostname = "coder-vscode.coder.infs.ch--georgiyshevoroshkin--AADL.main";
            userKnownHostsFile = "~/.ssh/known_hosts";
          };
        }
      );
    };
  };
}
