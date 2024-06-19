
{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.vpn.mullvad;
in {
  options.m.vpn.mullvad = {
    enable = mkEnableOption "enables mullvad";
  };

  config = mkIf cfg.enable {

  # Enable Mullvad VPN
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad; # `pkgs.mullvad` only provides the CLI tool, use `pkgs.mullvad-vpn` instead if you want to use the CLI and the GUI.

  environment.systemPackages = with pkgs; [
    mullvad-closest
  ];
  };
}
