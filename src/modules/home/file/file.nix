{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.u.file;
in
{
  # TODO: uniform filemanager everywhere
  options.u.file.enable = mkEnableOption "file packages";

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
      text = (if usr.style then (with config.lib.stylix.colors; ''
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
'') else "") + ''
        delete-in-background: true 
        delete-in-parallel: true 
        no-mouse: true
        sorting:
          order: "desc"
      '';
    };
  };
}
