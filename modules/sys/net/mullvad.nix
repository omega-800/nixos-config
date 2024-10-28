{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
with lib;
let
  cfg = config.m.net.vpn.mullvad;
in
{
  options.m.net.vpn.mullvad = {
    enable = mkEnableOption "enables mullvad";
  };

  config = mkIf cfg.enable {

    # Enable Mullvad VPN
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad; # `pkgs.mullvad` only provides the CLI tool, use `pkgs.mullvad-vpn` instead if you want to use the CLI and the GUI.
    };

    environment.systemPackages = with pkgs; [ mullvad-closest ];
  };
}
