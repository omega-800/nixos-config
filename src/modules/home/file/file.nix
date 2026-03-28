{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionals;
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
      ]
      ++ (optionals (!usr.minimal) [
        gdu
        eza
        gzip
        # unzip
        p7zip
      ])
      ++ (optionals usr.extraBloat [
        thunar
        # udiskie
        # udisks
        # sshfs
        # syncthing
        xz

        nix-tree
        nix-du
        graphviz
      ]);
    xdg.configFile."gdu/gdu.yaml" = {
      enable = true;
      text =
        ''
          delete-in-background: true 
          delete-in-parallel: true 
          no-mouse: true
          sorting:
            order: "desc"
        '';
    };
  };
}
