{
  inputs,
  lib,
  usr,
  config,
  pkgs,
  ...
}:
let
  cfg = config.m.dev.tools;
  inherit (lib)
    mkOption
    mkEnableOption
    mkMerge
    mkIf
    types
    ;
in
{
  options.m.dev.tools = {
    enable = mkEnableOption "devtools";
    disable = mkEnableOption "disabling devtools completely";
    zen-browser.enable = mkOption {
    type = types.bool;
    default = usr.browser == "zen-browser";
  };

  };

  config = mkMerge [
    (mkIf (cfg.enable && (!cfg.disable)) {
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
      environment.systemPackages = [ inputs.zen-browser.packages."${pkgs.system}".default ];
    })
    (mkIf (cfg.disable && (!cfg.enable)) {
      documentation = {
        enable = false;
        #ion.info.enable = false;
        man.enable = false;
        nixos.enable = false;
      };
    })
  ];
}
