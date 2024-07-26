{ lib, config, pkgs, usr, ... }:
with lib;
let
  nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
  cfg = config.u.user.kitty;
in
{
  options.u.user.kitty.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable && !usr.minimal;
  };

  config = mkIf (cfg.enable && usr.term == "kitty") {
    programs.kitty = {
      enable = true;
      package = (nixGL pkgs.kitty);
      font.size = mkForce 12;
      shellIntegration = {
        mode = "no-sudo no-rc";
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
