{
  usr,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.u.file.lf;
in
{
  options.u.file.lf.enable = mkOption {
    type = types.bool;
    default = config.u.file.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
      #      extraConfig = pkgs.substituteAll {
      #        src = ./lfrc;
      #        hi = "hello";
      #      };
      extraConfig = builtins.readFile ./lfrc;
    };
  };
}
