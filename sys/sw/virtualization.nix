{ config, pkgs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [ distrobox ];
  programs.virt-manager.enable = true;
  users.users.${userSettings.username}.extraGroups = [ "ibvirtd" ];
  virtualisation.libvirtd = {
    allowedBridges = [
      "nm-bridge"
      "virbr0"
    ];
    enable = true;
    qemu.runAsRoot = false;
  };
}