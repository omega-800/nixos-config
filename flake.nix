{
  description = "Nixos config flake";

  nixConfig = {
    #keep-outputs = false;       # Nice for developers
    #keep-derivations = false;   # Idem
    substitute = "true";
    extra-substituters = [
      "https://cache.nixos.org"
      "https://crane.cachix.org"
      "https://isabelroses.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://viperml.cachix.org"
      "https://cache.lix.systems"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "crane.cachix.org-1:8Scfpmn9w+hGdXH/Q9tTLiYAE/2dnJYRJP7kl80GuRk="
      "isabelroses.cachix.org-1:mXdV/CMcPDaiTmkQ7/4+MzChpOe6Cb97njKmBQQmLPM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
    cores = 0;
    max-jobs = 2;

    extra-experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    bash-prompt = "> ";
    use-xdg-base-directories = true;
  };

  outputs = { self, deploy-rs, ... }@inputs:
    let
      inherit (import ./modules/lib/builders { inherit inputs; })
        mapHosts mapHomes mapGeneric mapDroids mapModulesByArch mapAppsByArch
        mapPkgsByArch mapDeployments;
      # add more if needed
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      #TODO: move paths somewhere else?
      homeConfigurations = mapHomes ./modules/hosts { };
      nixosConfigurations = mapHosts ./modules/hosts { };
      nixOnDroidConfigurations = mapDroids ./modules/hosts { };
      systemConfigs = mapGeneric ./modules/hosts { };
      # devShells = mapModulesByArch ./modules/sh supportedSystems {
      #   inherit (inputs) nixvim;
      # };
      packages = mapPkgsByArch supportedSystems { };
      apps = mapAppsByArch supportedSystems { };
      deploy = mapDeployments ./modules/hosts { };
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
      # formatter
      # hydraJobs
    };

  inputs = {
    # döes nöt nörk :(
    # simplex = {
    #   url = "github:simplex-chat/simplex-chat";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    #TODO: nixpkgs.follows = correct-version

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager-unstable";
      };
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl.url = "github:nix-community/nixGL";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # hyprland.url =
    #   "github:hyprwm/Hyprland/cba1ade848feac44b2eda677503900639581c3f4?submodules=1";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # hycov = {
    #   url = "github:DreamMaoMao/hycov/115cba558d439cc25d62ce38b7c62cde83f50ef5";
    #   inputs.hyprland.follows = "hyprland";
    # };

    # nix-straight = {
    #   url = "github:librephoenix/nix-straight.el/pgtk-patch";
    #   flake = false;
    # };
    stylix.url = "github:danth/stylix";
    rust-overlay.url = "github:oxalica/rust-overlay";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    lonsdaleite = {
      url = "github:omega-800/lonsdaleite";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

    #TODO: implement
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # maybe maybe some day
    # flake-parts = {
    #   url = github:hercules-ci/flake-parts;
    #   inputs.nixpkgs-lib.follows = "nixpkgs";
    # };
    # flake-root.url = github:srid/flake-root;
    # mission-control.url = github:Platonic-Systems/mission-control;
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };
}
