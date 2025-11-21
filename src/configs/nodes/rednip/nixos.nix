{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-w520
    ./hardware-configuration.nix
  ];
  m = {
    /*
        fs.disko = {
          enable = true;
          root = {
            device = "/dev/sda";
            type = "btrfs";
            impermanence.enable = false;
          };
        };
    */
    os.boot.mode = "uefi";
    dev.psql.enable = true;
    sw = {
      flatpak.enable = false;
      printing.enable = false;
      miracast.enable = true;
    };
  };
  services.xserver = {
    # modules = [ config.boot.kernelPackages.nvidia_x11_legacy390 ];
    videoDrivers = [
      "nvidia"
      "intel"
    ];
  };
  boot = {
    # https://discourse.nixos.org/t/psa-for-those-with-hibernation-issues-on-nvidia/61834
    /*
      extraModprobeConfig = ''
        options nvidia_modeset vblank_sem_control=0
      '';
    */
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
  };
  environment.systemPackages = with pkgs; [
    mesa-demos
    pciutils
    inxi
    lshw
  ];
  hardware = {
    graphics.enable = true;
    intelgpu = {
      loadInInitrd = true;
      driver = "i915";
    };
    nvidia = {
      open = false;
      nvidiaSettings = true;
      # nvidiaPersistenced = true;
      videoAcceleration = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_390
      # .overrideAttrs (_: {
      #   postFixup = ''
      #     mv $out/lib/tls/* $out/lib
      #     rmdir $out/lib/tls
      #   '';
      # })
      ;
      modesetting.enable = true;
      powerManagement = {
        # https://discourse.nixos.org/t/black-screen-after-suspend-hibernate-with-nvidia/54341/22
        # no workey on 390 :(
        # enable = true;
        finegrained = false;
      };
      prime = {
        sync.enable = true;
        allowExternalGpu = true;
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
  };
  nixpkgs.config = {
    allowUnfreePredicate = _: false;
    # thanks, nvidia
    allowUnfree = true;
    nvidia.acceptLicense = true;
    allowBroken = false;
    # permittedInsecurePackages = [ "intel-media-sdk-23.2.2" ];
  };
  system.stateVersion = "24.11";
}
