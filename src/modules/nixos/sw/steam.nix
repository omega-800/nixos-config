{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.m.sw.steam;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.sw.steam.enable = mkEnableOption "steam";

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];
    environment = {
      systemPackages = with pkgs; [
        lutris
        mangohud
        heroic
        protonup-ng
        prismlauncher
      ];
      sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$${HOME}/.steam/root/compatibilitytools.d";
    };
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    programs.gamemode.enable = true;
  };
}
