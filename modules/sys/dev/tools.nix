{ inputs, lib, config, pkgs, ... }:
let
  cfg = config.m.dev.tools;
  inherit (lib) mkOption mkEnableOption mkMerge mkIf type;
in {
  options.m.dev.tools = {
    enable = mkEnableOption "enables devtools";
    disable = mkEnableOption "disables devtools completely";
    zen-browser.enable = mkEnableOption "enables zen-browser";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.nix-ld.enable = true;
      documentation = {
        enable = true;
        dev.enable = true;
        man = {
          enable = true;
          generateCaches = true;
          man-db.enable = true;
        };
        nixos = {
          enable = true;
          includeAllModules = true;
        };
      };
    })
    (mkIf cfg.zen-browser.enable {
      environment.systemPackages =
        [ inputs.zen-browser.packages."${pkgs.system}".default ];
    })
    (mkIf cfg.disable {
      documentation = {
        enable = false;
        #ion.info.enable = false;
        man.enable = false;
        nixos.enable = false;
      };
    })
  ];
}
