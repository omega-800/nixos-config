{
  description = "Nixos config flake";

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (lib.my) mapHosts mapHomes mapGeneric mapModules;
      #lib = (if stablePkgs then inputs.nixpkgs-stable.lib else inputs.nixpkgs.lib).extend
      pkgs = nixpkgs;
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit inputs pkgs;
          lib = self;
        };
      });

      # hacky hack hack for badly written bash scripts
      bashScriptToNix = n: p:
        (pkgs.writeShellScript n (builtins.replaceStrings [ "#!/bin/bash" ]
          [ "#!${pkgs.bash}/bin/bash" ]
          (builtins.readFile p)));

    in
    {
      homeConfigurations = mapHomes ./hosts { };
      nixosConfigurations = mapHosts ./hosts { };
      systemConfigs = mapGeneric ./hosts { };
      packages = mapModules ./packages import;
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    # OHMYGOD THANK YOU NUMTIDE
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url =
      "github:hyprwm/Hyprland/cba1ade848feac44b2eda677503900639581c3f4?submodules=1";
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
    omega-dwm = {
      url = "github:omega-800/dwm";
      flake = false;
    };
    omega-st = {
      url = "github:omega-800/st";
      flake = false;
    };
    omega-slock = {
      url = "github:omega-800/slock";
      flake = false;
    };
    # omega-nixvim = {
    #   url = "github:omega-800/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";

    nur.url = "github:nix-community/NUR";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    kaizen.url = "github:thericecold/kaizen";

    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };
}
