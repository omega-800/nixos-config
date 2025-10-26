{
  description = "omega's NixOS config flake";

  outputs =
    inputs:
    let
      inherit (import ./src/lib/flake { inherit inputs; })
        mapHomes
        mapHosts
        mapDroids
        mapGenerics
        mapPkgs
        mapApps
        mapDeployments
        mapChecks
        mapFormatters
        mapShells
        ;
    in
    {
      homeConfigurations = mapHomes;
      nixosConfigurations = mapHosts;
      nixOnDroidConfigurations = mapDroids;
      systemConfigs = mapGenerics;
      packages = mapPkgs;
      apps = mapApps;
      deploy = mapDeployments;
      checks = mapChecks;
      formatter = mapFormatters;
      devShells = mapShells;
      # devShells = mapModules ./modules/sh {
      #   inherit (inputs) nixvim;
      # };
      # hydraJobs
    };

  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        # nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };

    # döes nöt nörk :(
    # simplex = {
    #   url = "github:simplex-chat/simplex-chat";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    # TODO: remove unstable suffix bc of conventions
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    mango-unstable = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    mango-stable = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    disko-unstable = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko-stable = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    microvm-unstable = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    microvm-stable = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    system-manager-unstable = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    system-manager-stable = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-on-droid-unstable = {
      url = "github:nix-community/nix-on-droid/master";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager-unstable";
      };
    };
    nix-on-droid-stable = {
      url = "github:nix-community/nix-on-droid/master";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
        home-manager.follows = "home-manager-stable";
      };
    };
    attic-unstable = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    attic-stable = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixgl-unstable = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl-stable = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    deploy-rs-unstable = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    deploy-rs-stable = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    sops-nix-unstable = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix-stable = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
    stylix-unstable = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager-unstable";
      };
    };
    stylix-stable = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
        home-manager.follows = "home-manager-stable";
      };
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    /*
      firefox-addons = {
        url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
    */
    scawm-unstable = {
      url = "github:omega-800/scawm";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager-unstable";
        mango.follows = "mango-unstable";
      };
    };
    scawm-stable = {
      url = "github:omega-800/scawm";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
        home-manager.follows = "home-manager-stable";
        mango.follows = "mango-stable";
      };
    };
    lonsdaleite-unstable = {
      url = "github:omega-800/lonsdaleite";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    lonsdaleite-stable = {
      url = "github:omega-800/lonsdaleite";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    omega-dwm = {
      url = "github:omega-800/dwm";
      flake = false;
    };
    nixvim-unstable = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        # home-manager.follows = "home-manager-unstable";
      };
    };
    nixvim-stable = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
        # home-manager.follows = "home-manager-stable";
      };
    };

    # disko.url = "github:nix-community/disko";
    openconnect-sso-stable = {
      url = "github:ThinkChaos/openconnect-sso/fix/nix-flake";
      #url = "github:moinakb001/openconnect-sso";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    openconnect-sso-unstable = {
      url = "github:ThinkChaos/openconnect-sso/fix/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nur-stable = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nur-unstable = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
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
