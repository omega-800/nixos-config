{ config, lib, sys, globals, ... }:
with lib;
let cfg = config.m.net.ssh;
in {
  options.m.net.ssh.enable = mkOption {
    description = "enables ssh client";
    type = types.bool;
    default = config.m.net.enable;
  };
  config = mkIf cfg.enable {
    programs.ssh = mkMerge [
      {
        enableAskPassword = false;
        askPassword = "";
        forwardX11 = false;
        setXAuthLocation = false;
        startAgent = false;
      }
      (mkIf sys.hardened (with globals.sshConfig;
        {
          #inherit ciphers hostKeyAlgorithms kexAlgorithms macs;
          #pubkeyAcceptedKeyTypes = hostKeyAlgorithms;
        }))
    ];
    environment.persistence =
      lib.mkIf config.m.fs.disko.root.impermanence.enable {
        "/nix/persist".directories = [
          "/etc/ssh/authorized_keys.d"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };
  };
}
