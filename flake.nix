{
  description = "Nixos config flake";

  nixConfig = {
    #keep-outputs = false;       # Nice for developers
    #keep-derivations = false;   # Idem
    extra-experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    bash-prompt = "> ";
    use-xdg-base-directories = true;
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (import ./lib/builders { inherit inputs; })
        mapHosts mapHomes mapGeneric mapDroids mapModulesByArch;
      # add more if needed
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in {
      homeConfigurations = mapHomes ./hosts { };
      nixosConfigurations = mapHosts ./hosts { };
      nixOnDroidConfigurations = mapDroids ./hosts { };
      systemConfigs = mapGeneric ./hosts { };
      devShells = mapModulesByArch ./sh supportedSystems;
      packages = mapModulesByArch ./pkg supportedSystems;
    };

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager-unstable";
    };

    nixgl.url = "github:nix-community/nixGL";
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
    # nix-straight = {
    #   url = "github:librephoenix/nix-straight.el/pgtk-patch";
    #   flake = false;
    # };
    stylix.url = "github:danth/stylix";
    rust-overlay.url = "github:oxalica/rust-overlay";
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
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-stable = { url = "github:nix-community/nixvim/nixos-24.05"; };

    # disko.url = "github:nix-community/disko";

    nur.url = "github:nix-community/NUR";
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # kaizen.url = "github:thericecold/kaizen";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };
}
