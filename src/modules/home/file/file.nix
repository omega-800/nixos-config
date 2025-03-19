{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.u.file;
in
{
  options.u.file = {
    enable = mkEnableOption "enables file packages";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        rsync
        # tree (replaced by eza)
        eza
        gdu
      ]
      ++ (
        if !usr.minimal then
          [
            gzip
            unzip
          ]
        else
          [ ]
      )
      ++ (
        if usr.extraBloat then
          [
            xfce.thunar
            udiskie
            udisks
            sshfs
            syncthing
            xz
          ]
        else
          [ ]
      );
    xdg.configFile."gdu/gdu.yaml" = {
      enable = true;
      text = with config.lib.stylix.colors; ''
        style:
          selected-row:
            text-color: "#${base07}"
            background-color: "#${base03}"
          result-row:
            number-color: "#${base0D}"
            directory-color: "#${base0E}"
          footer:
            text-color: "#${base07}"
            background-color: "#${base0D}"
            number-color: "#${base06}"
          header:
            text-color: "#${base07}"
            background-color: "#${base0D}"
        delete-in-background: true 
        delete-in-parallel: true 
        no-mouse: true
        sorting:
          order: "desc"
      '';
    };
  };
}
