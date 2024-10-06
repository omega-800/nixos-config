{ pkgs, lib, config, ... }:
let cfg = config.m.fs.thunar;
in {
  options.m.fs.thunar.enable = lib.mkEnableOption "enables thunar";
  config = lib.mkIf cfg.enable {
    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
      };
      evince.enable = true;
    };
    services = {
      gvfs.enable = true; # Mount, trash, and other functionalities
      tumbler.enable = true; # Thumbnail support for images
    };
  };
}
