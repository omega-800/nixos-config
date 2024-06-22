{ sys, lib, config, pkgs, ... }: 
with lib;
let 
  cfg = config.u.media;
  nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
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
      bluez-tools
      ffmpeg
      imagemagick
      zathura
      (nixGL mpv)
      (nixGL ani-cli)
    ];
    home.file.".profile".text = "[ ! -s ~/.config/mpd/pid ] && mpd";
  };
}
