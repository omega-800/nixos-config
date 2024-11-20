{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionals;
  cfg = config.u.user;
in
{
  options.u.user.enable = mkEnableOption "enables userspace packages";

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        #starship
        # zbarimg -q --raw qrcode.png | pass otp insert totp-secret
        zbar
        sops
      ]
      ++ (optionals (!usr.minimal) [
        tree-sitter
      ])
      ++ (optionals usr.extraBloat [
        fortune
        cowsay
        lolcat
        prismlauncher
        #slic3r
        # needs to be updated, build is failing
        #cura
      ]);
  };
}
