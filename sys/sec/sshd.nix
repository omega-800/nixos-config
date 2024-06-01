{ lib, userSettings, systemSettings, ... }:
with lib; {
  # Enable incoming ssh
  services.openssh = mkMerge [
    ({
      enable = true;
      openFirewall = true;
    })
    (mkIf systemSettings.paranoid {
      allowSFTP = false;
      challengeResponseAuthentication = false;
      extraConfig = ''
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
        KexAlgorithms diffie-hellman-group-exchange-sha256
        MACs hmac-sha2-512,hmac-sha2-256
        Ciphers aes256-ctr,aes192-ctr,aes128-ctr
        HostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256
      '';
    })
  ];
  users.users.${userSettings.username}.openssh.authorizedKeys.keys = systemSettings.authorizedSshKeys;
}
