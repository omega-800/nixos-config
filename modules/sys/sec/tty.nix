{ config, sys, lib, ... }:
let
  cfg = config.m.sec.tty;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.tty = {
    enable = mkOption {
      description = "hardens tty";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    environment.extraInit = # sh
      ''
        TMOUT="$(( 60*10 ))";
        [ -z "$DISPLAY" ] && export TMOUT;
        case $( /usr/bin/tty ) in
        	/dev/tty[0-9]*) export TMOUT;;
        esac
      '';
  };
}
