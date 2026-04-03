# https://github.com/NixOS/nixpkgs/blob/91fe7d0b5f95da04adc60e11b352b70385bf689a/nixos/modules/services/wayland/swhkd.nix
# {
#   config,
#   pkgs,
#   lib,
#   ...
# }:
# let
#   inherit (lib)
#     mkIf
#     mkOption
#     mkEnableOption
#     mkPackageOption
#     optional
#     ;
#   cfg = config.services.swhkd;
# in
# {
#   options.services.swhkd = {
#     enable = mkEnableOption "simple wayland hotkey daemon";
#     package = mkPackageOption pkgs "swhkd" { };
#     installManpages = mkOption {
#       type = lib.types.bool;
#       default = true;
#       description = "install swhkd manual pages";
#     };
#     swhkdrc = mkOption {
#       type = lib.types.str;
#       default = "";
#       description = "contents of the system-wide swhkdrc file";
#     };
#   };
#
#   config = mkIf cfg.enable {
#     environment.systemPackages = [
#       cfg.package.bin
#       cfg.package.out
#     ] ++ optional cfg.installManpages cfg.package.man;
#     environment.etc."swhkd/swhkdrc".text = cfg.swhkdrc;
#     security.polkit.enable = true;
#   };
# }

# https://github.com/NixOS/nixpkgs/pull/306159/files
{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    optional
    ;
  cfg = config.services.swhkd;
in
{
  options.services.swhkd = {
    enable = mkEnableOption "simple wayland hotkey daemon";
    package = mkPackageOption pkgs "swhkd" { };
    swhkdrc = mkOption {
      type = lib.types.lines;
      default = "";
      description = "contents of the system-wide swhkdrc file. See {manpage}`swhkd(5) for more details on the config format.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ] ++ [ cfg.package.out ];
    environment.etc."swhkd/swhkdrc".text = cfg.swhkdrc;
    security.polkit.enable = true;
  };
}
