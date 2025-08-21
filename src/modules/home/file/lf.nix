{
  usr,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
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
