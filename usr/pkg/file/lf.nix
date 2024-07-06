{ usr, config, lib, ... }:
with lib;
let cfg = config.u.file.lf;
in {
  options.u.file.lf.enable = mkOption {
    type = types.bool;
    default = config.u.file.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
      extraConfig = builtins.readFile ./lfrc;
    };
  };
}
