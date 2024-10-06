{ pkgs, config, sys, lib, ... }:
let
  cfg = config.m.sec.gpg;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.gpg = {
    enable = mkOption {
      description = "enables gpg";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
      settings = { default-cache-ttl = 600; };
    };
  };
}
