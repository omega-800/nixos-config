{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let 
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "nixie"; # hostname
        profile = "personal"; # select a profile defined from my profiles directory
        timezone = "Europe/Zurich"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        kbLayout = "de_CH-latin1"; # select keyboard layout
        bootMode = "bios"; # uefi or bios
        bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = "/dev/sda"; # device identifier for grub; only used for legacy (bios) boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "omega"; # username
        name = ""; # name/identifier
        email = ""; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        theme = "uwunicorn-yt"; # selcted theme from my themes directory (./themes/)
        wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        # window manager type (hyprland or x11) translator
        wmType = if (wm == "hyprland") then "wayland" else "x11";
        browser = "qutebrowser"; # Default browser; must select one from ./user/app/browser/
        defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
        term = "alacritty"; # Default terminal command;
        font = "Intel One Mono"; # Selected font
        fontPkg = pkgs.intel-one-mono; # Font package
        editor = "nvim"; # Default editor;
        # editor spawning translator
        # generates a command that can be used to spawn editor inside a gui
        # EDITOR and TERM session variables must be set in home.nix or other module
        # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
        spawnEditor = if (editor == "emacsclient") then
                        "emacsclient -c -a 'emacs'"
                      else
                        (if ((editor == "vim") ||
                             (editor == "nvim") ||
                             (editor == "nano")) then
                               "exec " + term + " -e " + editor
                         else
                           editor);

      pkgs = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
              then
                pkgs-stable
              else
                (import nixpkgs-patched {
                  system = systemSettings.system;
                  config = {
                    allowUnfree = true;
                    allowUnfreePredicate = (_: true);
                  };
                  overlays = [ inputs.rust-overlay.overlays.default ];
                }));

      nixpkgs-patched =
        (import inputs.nixpkgs { system = systemSettings.system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
          patches = [ ./patches/emacs-no-version-check.patch ];
        };

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-emacs = import inputs.emacs-pin-nixpkgs {
        system = systemSettings.system;
      };

      pkgs-kdenlive = import inputs.kdenlive-pin-nixpkgs {
        system = systemSettings.system;
      };

      # configure lib
      # use nixpkgs if running a server (homelab or worklab profile)
      # otherwise use patched nixos-unstable nixpkgs
      lib = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
             then
               inputs.nixpkgs-stable.lib
             else
               inputs.nixpkgs.lib);

      # use home-manager-stable if running a server (homelab or worklab profile)
      # otherwise use home-manager-unstable
      home-manager = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
             then
               inputs.home-manager-stable
             else
               inputs.home-manager-unstable);

      # Systems that can run tests:
      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor =
        forAllSystems (system: import inputs.nixpkgs { inherit system; });

      };
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/skribl/configuration.nix
        ./sys
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
