{ lib, ... }:
let
  inherit (lib) mkDefault mkOverride;
  nasDirs = [ "/store/backup" "/store/share" "/store/share/img" "/store/pers" ];
in {
  imports = [ ];
  m = {
    hw = {
      kernel = {
        zen = mkDefault false;
        swappiness = mkDefault 15;
      };
      audio.enable = mkDefault false;
      io = {
        enable = mkDefault false;
        touchpad.enable = mkDefault false;
        swapCaps.enable = mkDefault false;
      };
      openGL.enable = mkDefault false;
      power = {
        enable = mkOverride 900 true;
        performance = mkOverride 900 false;
        powersave = mkOverride 900 true;
      };
    };
    sec = {
      enable = mkDefault true;
      clamav.enable = mkDefault true;
    };
    dev = {
      enable = mkDefault true;
      docker.enable = mkDefault true;
      virt.enable = mkDefault true;
      mysql.enable = mkDefault false;
      tools.disable = mkDefault true;
    };
    net = {
      enable = mkDefault true;
      macchanger.enable = mkDefault true;
      firewall.enable = mkDefault true;
      ssh.enable = mkDefault true;
      sshd.enable = mkDefault true;
      wifi.enable = mkDefault false;
      vpn = {
        forti.enable = mkDefault false;
        mullvad.enable = mkDefault false;
        openvpn.enable = mkDefault false;
        wg.enable = mkDefault true;
      };
    };
    fs = {
      automount.enable = mkDefault false;
      dirs = {
        enable = mkDefault true;
        extraDirs = mkDefault [
          {
            path = "/srv";
            mode = "0744";
            user = "root";
          }
          {
            path = "/store";
            mode = "0744";
            user = "root";
          }
        ];
      };
    };
    sw.enable = mkDefault false;
  };
  #https://github.com/nix-community/srvos/blob/main/nixos/common/zfs.nix

  # You may also find this setting useful to automatically set the latest compatible kernel:
  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  #users.mutableUsers = false;

  environment = {
    # Don't install the /lib/ld-linux.so.2 and /lib64/ld-linux-x86-64.so.2
    # stubs. Server users should know what they are doing.
    stub-ld.enable = mkDefault false;
  };
}
