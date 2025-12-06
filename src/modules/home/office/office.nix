{
  sys,
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption optionals;
  cfg = config.u.office;
in
{
  options.u.office = {
    enable = mkEnableOption "office packages";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        # "obsidian"
      ];
    home.packages =
      with pkgs;
      [
        libreoffice
        gimp
        /*
          (pkgs.runCommand
            "xournalpp"
            { nativeBuildInputs = [ pkgs.makeWrapper ]; }
            "makeWrapper ${pkgs.xournalpp}/bin/xournalpp $out/bin/xournalpp --set GDK_SCALE 2 --set GDK_DPI_SCALE 0.5"
          )
        */
      ]
      ++ (optionals (!usr.minimal) [
        inkscape
        xournalpp
      ])
      ++ (optionals usr.extraBloat (
        [
          # obsidian
          drawio
          kdePackages.skanpage
          (if (usr.wmType == "x11") then gpick else hyprpicker)
        ]
        ++ (optionals (sys.profile == "pers") [
          cointop
          valentina
          homebank
        ])
      ));
    # TODO: 
    home.file.".local/share/xournalpp/ui/xournalpp.css".text = ''
      toolbar button
      {
      	padding: 18px
      }

      toolbar image 
      {
          -gtk-icon-transform: scale(0.5);
      }
    '';
  };
}
