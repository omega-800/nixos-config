{ pkgs, lib, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  m = {
    os.boot.mode = "uefi";
    # net.iface = "enp0s31f6";
    dev.docker.enable = false;
  };

  users.users.anon = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "podman"
      "adbusers"
    ];
    packages = with pkgs; [
      alacritty
      firefox
      vscodium
    ];
  };
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  system.stateVersion = "25.05";
}
