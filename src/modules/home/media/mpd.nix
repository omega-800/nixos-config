{
  lib,
  config,
  pkgs,
  usr,
  globals,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.media.mpd;
in
{
  options.u.media.mpd.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable && (!usr.minimal);
  };

  config = mkIf cfg.enable {

    home = {
      packages = with pkgs; [ mpc ];
      file.".profile".text = "[ ! -s ~/.config/mpd/pid ] && mpd";
    };
    programs.rmpc = {
      enable = true;
    };
    services = {
      mpd = {
        enable = true;
        musicDirectory = globals.envVars.XDG_MUSIC_DIR;
        network.startWhenNeeded = true;
        enableSessionVariables = true;
        extraConfig = ''
          zeroconf_enabled "no"
        '';
      };
      mpd-mpris.enable = true;
    };
    xdg.configFile."mpd/mpd.conf".text = config.services.mpd.generatedConfig;
  };
}
