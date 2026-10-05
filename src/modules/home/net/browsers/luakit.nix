{
  usr,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.u.net.luakit;
  inherit (lib) mkOption types mkIf;
in
{
  options.u.net.luakit.enable = mkOption {
    type = types.bool;
    default = usr.browser == "luakit";
  };
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ luakit ];
    };
    xdg.configFile."luakit/userconf.lua".text = ''
    '';
  };
}
