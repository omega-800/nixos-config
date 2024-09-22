{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  m = {
    hw.power.enable = false;
    os.boot.mode = "ext";
    sec = {
      enable = false;
      clamav.enable = false;
    };
    dev = {
      enable = false;
      docker.enable = false;
      virt.enable = false;
      mysql.enable = false;
    };
    net = {
      macchanger.enable = false;
      firewall.enable = false;
      ssh.enable = false;
      vpn.wg.enable = false;
    };
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "22.05";
  #system.stateVersion = "23.11"; 
}
