{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # TODO: implement for all
  programs.firejail.enable = true;
  # TODO: figure out why this doesn't do jack
  boot = {
    kernelParams = [ "kernel.unprivileged_userns_clone=1" ];
    # huh
    kernel.sysctl."kernel.unprivileged_userns_clone" = lib.mkForce "1";

    extraModprobeConfig = ''
      # Keep Bluetooth coexistence disabled for better BT audio stability
      options iwlwifi bt_coex_active=0

      # Enable software crypto (helps BT coexistence sometimes)
      options iwlwifi swcrypto=1

      # Disable power saving on Wi-Fi module to reduce radio state changes that might disrupt BT
      options iwlwifi power_save=0

      # Disable Unscheduled Automatic Power Save Delivery (U-APSD) to improve BT audio stability
      options iwlwifi uapsd_disable=1

      # Disable D0i3 power state to avoid problematic power transitions
      options iwlwifi d0i3_disable=1

      # Set power scheme for performance (iwlmvm)
      options iwlmvm power_scheme=1
    '';
  };

  security = {
    allowUserNamespaces = true;
    unprivilegedUsernsClone = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    bluetooth.settings.General.ControllerMode = "bredr";
    nvidia = {
      open = false;
      nvidiaSettings = true;
      videoAcceleration = true;
      modesetting.enable = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
