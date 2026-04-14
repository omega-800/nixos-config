{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-w520
    ./hardware-configuration.nix
  ];

  # hardware = {
  #   enableAllFirmware = true;
  #   enableRedistributableFirmware = true;
  #   bluetooth.powerOnBoot = lib.mkForce true;
  # };

# pactl set-card-profile alsa_card.pci-0000_00_1b.0 output:analog-stereo
  # TODO: pipewire-pulse.conf
# context.properties = {
#     default.card.profile = "output:analog-stereo"
# }
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
    sw = {
      flatpak.enable = false;
      printing.enable = false;
      miracast.enable = true;
    };
    hw.audio.pipewire = true;
  };
  services.xserver = {
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
      package =
        # config.boot.kernelPackages.nvidiaPackages.legacy_390
        # aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

        config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "535.274.02";
          sha256_64bit = "sha256-O071TwaZHm3/94aN3nl/rZpFH+5o1SZ9+Hyivo5/KTs=";
          sha256_aarch64 = "sha256-PgHcrqGf4E+ttnpho+N8SKsMQxnZn29fffHXGbeAxRw=";
          openSha256 = "sha256-4KRHuTxlU0GT/cWf/j3aR7VqWpOez1ssS8zj/pYytes=";
          settingsSha256 = "sha256-BXQMXKybl9mmsp+Y+ht1RjZqnn/H3hZfyGcKIGurxrI=";
          persistencedSha256 = "sha256-/ZvAsvTjjiM/U3gn0DbxUguC3VvHbopyQ3u6+RYkzKk=";
        }

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
