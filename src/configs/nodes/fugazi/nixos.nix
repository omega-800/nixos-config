{
  lib,
  pkgs,
  usr,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  m.hw = {
    # audio.pipewire = false;
    io = {
      enable = true;
      tablet.enable = true;
    };
  };

  # TODO: change
  # KERNEL=="hid*", ATTRS{idVendor}=="256c", MODE="0666"
  # KERNEL=="input", ATTRS{idVendor}=="256c", MODE="0666"
  services.udev.extraRules = ''
        # this is so fucking sketchy
        KERNEL=="*", MODE="0777"

        # KERNEL=="*", ATTRS{idVendor}=="256c", MODE="0777", GROUP="input"
        # KERNEL=="uinput", MODE="0777", GROUP="input"

    # ensure uinput device is accessible
    # KERNEL=="uinput", MODE="0660", GROUP="input"

    # Huion H320M vendor id 256c — set device node to input group
    # ATTRS{idVendor}=="256c", MODE="0660", GROUP="input"
  '';
  # systemd.user.services.opentabletdriver = {
  # serviceConfig = {
  # User = "otd";
  # Group = "input";
  # ProtectSystem = "no";
  # ProtectHome = "no";
  # PrivateDevices = false;
  # DeviceAllow = "/dev/uinput rwm";
  #     };
  #
  #   };
  # users.users.${usr.username}.extraGroups = [ "input" ];
  # users = {
  #   groups.otd = {};
  #   extraUsers.otd = { isSystemUser = true; group = "otd"; extraGroups = [ "input" ]; };
  # };

  # ACTION!="add|remove|bind", GOTO="huion_switcher_end"
  # ATTRS{idVendor}=="256c", IMPORT{program}="${lib.getExe pkgs.huion-switcher} %S%p"
  # ATTRS{idVendor}=="256c", ENV{HID_UNIQ}=="", ENV{HUION_FIRMWARE_ID}!="", ENV{HID_UNIQ}="$env{HUION_FIRMWARE_ID}"
  # ATTRS{idVendor}=="256c", ENV{UNIQ}=="", ENV{HUION_FIRMWARE_ID}!="", ENV{UNIQ}="$env{HUION_FIRMWARE_ID}"
  # LABEL="huion_switcher_end"

  # TODO: implement for all
  programs.firejail.enable = true;
  boot = {
    # TODO: figure out why this doesn't do jack
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
    enableAllFirmware = true;
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
