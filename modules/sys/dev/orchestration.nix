{ sys, config, lib, pkgs, ... }:
let
  cfg = config.m.dev.dictate;
  inherit (lib) types mkOption mkIf;
in
{
  options.m.dev.dictate.enable = mkOption {
    description = "enables orchestration tools";
    type = types.bool;
    default = config.m.dev.enable && (builtins.elem "master" sys.flavors);
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ deploy-rs.deploy-rs ];
  };
}
