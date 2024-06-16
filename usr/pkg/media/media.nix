{ sys, lib, config, pkgs, ... }: 
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
      ffmpeg
      imagemagick
    ] ++ (if sys.genericLinux then [] else [
      mpv
      ani-cli
    ]);
  };
}
