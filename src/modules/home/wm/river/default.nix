{
  config,
  pkgs,
  usr,
  lib,
  ...
}:
let
  inherit (pkgs) nixGL;
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.u.wm.river;
in
{
  options.u.wm.river.enable = mkOption {
    type = types.bool;
    default = usr.wm == "river";
  };

  imports = [ ./yambar.nix ];

  config = mkIf cfg.enable {
    home.packages = [ pkgs.swaybg ];

    wayland.windowManager.river = {
      enable = true;
      package = nixGL pkgs.river;
      xwayland.enable = true;
      systemd.enable = true;
      extraConfig =
        (builtins.readFile ./init)
        + ''
          swaybg --image ${config.stylix.image} --mode fill
        '';
    };
  };
}
