{ lib, config, usr, pkgs, ... }:
let cfg = config.m.sec.priv;
in {
  options.m.sec.priv = {
    enable = lib.mkOption {
      description = "enables privileged access";
      type = lib.types.bool;
      default = config.m.sec.enable;
    };
    sudo.enable = lib.mkEnableOption "enables sudo, doas otherwise";
  };

  config = {
    security = {
      sudo.enable = cfg.sudo.enable;
      doas = lib.mkIf (cfg.enable && !cfg.sudo.enable) {
        enable = true;
        extraRules = [{
          users = [ "${usr.username}" ];
          keepEnv = true;
          persist = true;
        }];
      };
    };

    environment.systemPackages = if (cfg.enable && !cfg.sudo.enable) then
      [ (pkgs.writeScriptBin "sudo" ''exec doas "$@"'') ]
    else
      [ ];
  };
}
