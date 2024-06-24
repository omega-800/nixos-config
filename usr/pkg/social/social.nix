{ sys, usr, lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.social;
in {
  options.u.social = {
    enable = mkEnableOption "enables social packages";
  };
 
  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "discord"
    ];
    home.packages = with pkgs; [
      aerc
    ] ++ (if usr.extraBloat && sys.profile == "pers" then [
      discord
    ] else []);
  };
}
