{ usr, lib, config, pkgs, globals, ... }:
with lib;
let cfg = config.u.user;
in {
  options.u.user = { enable = mkEnableOption "enables userspace packages"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        #starship
      ] ++ (if !usr.minimal then [ tree-sitter feh ] else [ ])
      ++ (if usr.extraBloat then [
        fortune
        cowsay
        lolcat
        prismlauncher
        #slic3r
        # needs to be updated, build is failing
        #cura
      ] else
        [ ]);
    programs.password-store = {
      enable = true;
      settings = {
        inherit (globals.envVars) PASSWORD_STORE_DIR EDITOR;
        PASSWORD_STORE_CLIP_TIME = "60";
        PASSWORD_STORE_GENERATED_LENGTH = "32";
      };
      package =
        pkgs.pass.withExtensions (exts: with exts; [ pass-checkup pass-otp ]);
    };
    services.pass-secret-service = {
      enable = true;
      storePath = globals.envVars.PASSWORD_STORE_DIR;
    };
  };
}
