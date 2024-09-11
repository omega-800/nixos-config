{ config, lib, sys, globals, ... }:
with lib;
let cfg = config.m.ssh;
in {
  options.m.ssh = { enable = mkEnableOption "enables ssh client"; };
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
  };
}
