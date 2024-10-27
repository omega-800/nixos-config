{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.u.utils.fetch;
in
{
  options.u.utils.fetch.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ fastfetch ]
      ++ (
        if usr.extraBloat then
          [
            owofetch
            onefetch
            bunnyfetch
            ghfetch
          ]
        else
          [ ]
      );
  };
}
