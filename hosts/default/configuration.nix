# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  boot.loader = {
    # Use the GRUB 2 boot loader.
    grub = {
      enable = true;
      device = "/dev/sda"; # or "nodev" for efi only
      # efiSupport = true;
      # efiInstallAsRemovable = true;
    };
    # efi.efiSysMountPoint = "/boot/efi";
    # Define on which hard drive you want to install Grub.
  };

  networking = {
    hostName = "nixie"; # Define your hostname.
    # Pick only one of the below networking options.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de_CH-latin1";
    # useXkbConfig = true; # use xkb.options in tty.
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omega = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      neovim
      waybar
      dunst
      libnotify
      swww
      alacritty
      kitty
      rofi-wayland 

    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "omega" = import ./home.nix;
    };  
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
      systemPackages = with pkgs; [
        vim
        wget
        curl
        git
      ];
      sessionVariables = {
        # WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
      };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      hyprland = {
        enable = true;
        # nvidiaPatches = true;
        xwayland.enable = true;
      };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      # daemon.settings.bip = "???.???.???.???/??";
    };
  };

  security.rtkit.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  # List services that you want to enable:

  services = {
    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    /*
    xserver = {
        enable = true;
        libinput.enable = true;
        windowManager.qtile.enable = true;
    };
    */

    openssh = {
        enable = true;
        allowSFTP = true;
    };

    sshd.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
          enable = true;
          support32Bit = true;
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [ "omega" "root" ];
      experimental-features = [ "nix-command" "flakes" ];
      # warn-dirty = false;

      # avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true; 
      keep-derivations = true; 
    };  
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

