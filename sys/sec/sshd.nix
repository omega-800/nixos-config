{ config, lib, sys, usr, ... }:
with lib;
let cfg = config.m.sshd;
in {
  options.m.sshd = {
    enable = mkEnableOption "enables creation of directories";
    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG4vyC8dYQEEv7JUeWmHqeKNBrB/GmV4sXED4dkhT2u omega@archie"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9b/N++cCJpu4Bo4Lftg1FdmW33q59XdEdk2HBei/9e omega@nixie"
      ];
    };
  };
  # sops.secrets.sshd_port = {};
  # Enable incoming ssh
  config = mkIf cfg.enable {
    services.openssh = mkMerge [
      ({
        enable = true;
        openFirewall = true;
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
      })
      (mkIf sys.hardened {
        allowSFTP = false;
        settings = {
          KbdInteractiveAuthentication = false;
          # unbind gnupg sockets if they exists
          StreamLocalBindUnlink = true;
          KexAlgorithms = [
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
            "diffie-hellman-group16-sha512"
            "diffie-hellman-group18-sha512"
            "diffie-hellman-group-exchange-sha256"
            "sntrup761x25519-sha512@openssh.com"
          ];
        };
        extraConfig = ''
          LogLevel VERBOSE
          MaxSessions 2
          Port 51423 #TODO: fix this without readFile $''${config.sops.secrets.sshd_port.path}
          TCPKeepAlive no
          PasswordAuthentication no
          PermitRootLogin no
          PermitEmptyPasswords no
          PermitUserEnvironment no
          UseDNS no
          StrictModes yes
          IgnoreRhosts yes
          RhostsAuthentication no
          RhostsRSAAuthentication no
          ClientAliveInterval 300
          ClientAliveCountMax 0
          MaxAuthTries 3
          AllowTcpForwarding no
          X11Forwarding no
          AllowAgentForwarding no
          AllowStreamLocalForwarding no
          AuthenticationMethods publickey
          HostbasedAuthentication no
          MACs hmac-sha2-512,hmac-sha2-256
          Ciphers aes256-ctr,aes192-ctr,aes128-ctr
          HostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256
        '';
      })
    ];
    # TODO: take these from sops
    users.users.${usr.username}.openssh.authorizedKeys.keys =
      cfg.authorizedKeys;
  };
}
