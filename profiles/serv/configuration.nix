{ lib, config, ... }: {
  imports = [ ];
  m = {
    kernel = {
      zen = lib.mkDefault false;
      swappiness = lib.mkDefault 15;
    };
    docker.enable = lib.mkDefault true;
    virt.enable = lib.mkDefault true;
    automount.enable = lib.mkDefault true;
    macchanger.enable = lib.mkDefault true;
    devtools.disable = lib.mkDefault true;
    vpn = {
      forti.enable = lib.mkDefault false;
      mullvad.enable = lib.mkDefault false;
      openvpn.enable = lib.mkDefault false;
      wg.enable = lib.mkDefault true;
    };
    dirs = {
      enable = lib.mkDefault true;
      extraDirs = lib.mkDefault [{
        path = "/services";
        mode = "0744";
        user = "root";
      }];
    };
  };
  #https://github.com/nix-community/srvos/blob/main/nixos/common/zfs.nix

  # You may also find this setting useful to automatically set the latest compatible kernel:
  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Use the same default hostID as the NixOS install ISO and nixos-anywhere.
  # This allows us to import zfs pool without using a force import.
  # ZFS has this as a safety mechanism for networked block storage (ISCSI), but 
  # in practice we found it causes more breakages like unbootable machines,
  # while people using ZFS on ISCSI is quite rare.
  networking.hostId = lib.mkDefault "8425e349";

  services.zfs = lib.mkIf (config.boot.zfs.enabled) {
    autoSnapshot.enable = true;
    # defaults to 12, which is a bit much given how much data is written
    autoSnapshot.monthly = lib.mkDefault 1;
    autoScrub.enable = true;
  };

  # Notice this also disables --help for some commands such es nixos-rebuild
  # No need for fonts on a server
  fonts.fontconfig.enable = lib.mkDefault false;
  #users.mutableUsers = false;

  environment = {
    # Don't install the /lib/ld-linux.so.2 and /lib64/ld-linux-x86-64.so.2
    # stubs. Server users should know what they are doing.
    stub-ld.enable = lib.mkDefault false;
  };
}
