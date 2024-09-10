{ config, lib, sys, usr, globals, ... }:
with lib;
let cfg = config.m.sshd;
in {
  options.m.sshd = {
    enable = mkEnableOption "enables ssh server";
    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = flatten (my.cfg.getCfgAttrOfAllHosts "sys" "pubkeys");
      description = "authorized ssh keys to be added";
    };
  };
  # sops.secrets.sshd_port = {};
  # Enable incoming ssh
  config = mkIf cfg.enable {
    services.openssh = mkMerge [
      ({
        enable = true;
        openFirewall = true;
        banner = ''
          Thank you for your login credentials
          :)
        '';
        # Only allow system-level authorized_keys to avoid injections.
        # We currently don't enable this when git-based software that relies on this is enabled.
        # It would be nicer to make it more granular using `Match`.
        # However those match blocks cannot be put after other `extraConfig` lines
        # with the current sshd config module, which is however something the sshd
        # config parser mandates.
        authorizedKeysFiles = lib.mkIf (!config.services.gitea.enable
          && !config.services.gitlab.enable && !config.services.gitolite.enable
          && !config.services.gerrit.enable && !config.services.forgejo.enable)
          (lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ]);
        settings = { PrintMotd = true; };
      })
      (mkIf sys.hardened {
        allowSFTP = false;
        ports = [ 51423 ];
        settings = with globals.sshConfig; {
          KexAlgorithms = kexAlgorithms;
          MACs = macs;
          Ciphers = ciphers;
          HostKeyAlgorithms = hostKeyAlgorithms;
          # unbind gnupg sockets if they exists
          StreamLocalBindUnlink = true;
          LogLevel = "VERBOSE";
          TCPKeepAlive = false;
          MaxSessions = 2;
          GatewayPorts = "no";
          KbdInteractiveAuthentication = false;
          AllowUsers = [ usr.username ];
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          PermitEmptyPasswords = false;
          PermitUserEnvironment = false;
          UseDNS = false;
          UsePAM = true;
          StrictModes = true;
          IgnoreRhosts = true;
          RhostsAuthentication = false;
          RhostsRSAAuthentication = false;
          ClientAliveInterval = 300;
          ClientAliveCountMax = 0;
          MaxAuthTries = 3;
          AllowTcpForwarding = false;
          X11Forwarding = false;
          AllowAgentForwarding = false;
          AllowStreamLocalForwarding = false;
          AuthenticationMethods = "publickey";
          HostbasedAuthentication = false;
        };
      })
    ];
    # TODO: take these from sops
    users.users.${usr.username}.openssh.authorizedKeys.keys =
      cfg.authorizedKeys;
  };
}
