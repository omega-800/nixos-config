{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  inherit (pkgs) nixGL;
  cfg = config.u.media.mpv;
in
{
  options.u.media.mpv.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable && (!usr.minimal);
  };

  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      # TODO: 
      # package = nixGL (
      #   pkgs.mpv-unwrapped.wrapper {
      #     mpv = pkgs.mpv-unwrapped.override {
      #       vapoursynthSupport = true;
      #       ffmpeg = pkgs.ffmpeg-full;
      #     };
      #     scripts = with pkgs.mpvScripts; [
      #       uosc
      #       sponsorblock
      #       autoload
      #     ];
      #     youtubeSupport = true;
      #   }
      # );
    };
  };
}
