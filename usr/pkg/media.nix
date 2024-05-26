{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.media;
in {
  options.u.media = {
    enable = mkEnableOption "enables media packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpd
      mpc-cli
      ncmpcpp
      pipewire
      pavucontrol
      bluez
      ani-cli
      mpv
      ffmpeg
      imagemagick
    ];
  };
}
