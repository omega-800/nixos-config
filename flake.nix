{
  description = "Nixos config flake";

  outputs = { self, nixpkgs, ... }@inputs: 
  let 
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        hostname = "z"; # hostname
        profile = "work"; # select a profile defined from my profiles directory
        system = "x86_64-linux"; # system arch
        genericLinux = false;
      };

      stablePkgs = ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"));

      pkgs = (if stablePkgs then pkgs-stable else
                (import nixpkgs-patched {
                  system = systemSettings.system;
                  config = {
                    allowUnfree = true;
                    allowUnfreePredicate = (_: true);
                  };
                  overlays = [ inputs.rust-overlay.overlays.default ] ++ (if systemSettings.genericLinux then [ inputs.nixgl.overlay ] else []);
                }));

      nixpkgs-patched =
        (import inputs.nixpkgs { system = systemSettings.system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
        };

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      # configure lib
      # use nixpkgs if running a server (homelab or worklab profile)
      # otherwise use patched nixos-unstable nixpkgs
      lib = (if stablePkgs then inputs.nixpkgs-stable.lib else inputs.nixpkgs.lib);

      # use home-manager-stable if running a server (homelab or worklab profile)
      # otherwise use home-manager-unstable
      home-manager = (if stablePkgs then inputs.home-manager-stable else inputs.home-manager-unstable);

      # Systems that can run tests:
      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });
  
      # hacky hack hack for badly written bash scripts
      bashScriptToNix = n: p: (pkgs.writeShellScript n (builtins.replaceStrings [ "#!/bin/bash" ] [ "#!${pkgs.bash}/bin/bash" ] (builtins.readFile p)));

    in {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./profiles/default/home.nix
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") 
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit inputs;
            inherit bashScriptToNix;
          };
        };
      };
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          # load configuration.nix from selected PROFILE
          modules = [
            ./profiles/default/configuration.nix 
            (./. + "/hosts" + ("/" + systemSettings.hostname) + "/configuration.nix")
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          ];
          specialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit inputs;
            inherit bashScriptToNix;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    hyprland.url = "github:hyprwm/Hyprland/cba1ade848feac44b2eda677503900639581c3f4?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hycov = {
      url = "github:DreamMaoMao/hycov/115cba558d439cc25d62ce38b7c62cde83f50ef5";
      inputs.hyprland.follows = "hyprland";
    };
    nix-straight = {
      url = "github:librephoenix/nix-straight.el/pgtk-patch";
      flake = false;
    };
    stylix.url = "github:danth/stylix";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixgl.url = "github:nix-community/nixGL";
		firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
