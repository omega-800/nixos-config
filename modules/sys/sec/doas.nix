{ lib, config, usr, pkgs, ... }:
let cfg = config.m.sec.priv;
in {
  options.m.sec.priv = {
    enable = lib.mkEnableOption "enables privileged access";
    sudo.enable = lib.mkEnableOption "enables sudo, doas otherwise";
  };

  config = lib.mkIf cfg.enable {
    security = {
      sudo.enable = cfg.sudo.enable;
      doas = lib.mkIf (!cfg.sudo.enable) {
        enable = true;
        extraRules = [{
          users = [ "${usr.username}" ];
          keepEnv = true;
          persist = true;
        }];
      };
    };

    environment.systemPackages =
      if cfg.sudo.enable then
        [ ]
      else
        [ (pkgs.writeScriptBin "sudo" ''exec doas "$@"'') ];
  };
}
