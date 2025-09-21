{ modulesPath, lib, ... }:
let
  inherit (lib) mkDefault mkOverride;
  nasDirs = [
    "/store/backup"
    "/store/share"
    "/store/share/img"
    "/store/pers"
  ];
in
{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    #TODO: test
    # (modulesPath + "/profiles/perlless.nix") 
    # https://sidhion.com/blog/posts/nixos_server_issues/
  ];
  m = {
    hw = {
      kernel = {
        zen = mkDefault false;
        swappiness = mkDefault 15;
      };
      audio.enable = mkDefault false;
      io = {
        enable = false;
        touchpad.enable = false;
      };
      openGL.enable = mkDefault false;
      power = {
        enable = mkOverride 900 true;
        performance = mkOverride 900 false;
        powersave = mkOverride 900 true;
      };
    };
    dev = {
      docker.enable = mkDefault false;
      virt.enable = mkDefault false;
      mysql.enable = mkDefault false;
      tools.disable = mkDefault true;
    };
    net = {
      wifi.enable = mkDefault false;
      vpn = {
        forti.enable = mkDefault false;
        mullvad.enable = mkDefault false;
        wg.enable = mkDefault false;
      };
      wol.enable = mkDefault false;
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
