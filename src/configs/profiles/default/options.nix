{
  config,
  lib,
  pkgs,
  PATHS,
  ...
}:
let
  # kind of a hacky workaround but if it works then it works
  inherit (import (PATHS.LIBS + /omega/dirs.nix) { inherit lib; })
    listNixModuleNames
    listFilterDirs
    listDirs
    ;
  inherit (import (PATHS.LIBS + /omega/cfg.nix) { inherit lib; }) filterHosts;
  inherit (lib) mkOption types;
in
{
  options.c = {
    sys = {
      pubkeys = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "public ssh key(s)";
      };
      identityFile = mkOption {
        type = types.str;
        default = "~/.ssh/id_ed25519";
        description = "private ssh key file";
      };
      hostname = mkOption {
        type = types.str;
        default = "nixie";
      }; # will be set to the dirname of the host configs
      profile =
        let
          profiles = listFilterDirs (
            n: v:
            !(builtins.elem n [
              "default"
              "partials"
            ])
          ) PATHS.PROFILES;
        in
        mkOption {
          type = types.enum profiles;
          default = "pers";
        }; # select a profile defined from my profiles directory
      #TODO: implement
      flavors = mkOption {
        type = types.listOf (
          types.enum [
            "builder" # beefy machines for building derivations
            "developer" # enables devtools
            "master" # orchestrator
            "slave" # orchestrated
            "worker" # peasant doing menial tasks
            "storer" # data horder
            "hoster" # web services provider
            "grandparent" # hypervisor
            "parent" # runs vm's / containers
            "child" # vm/container
          ]
        );
        default = [ ];
      };
      #TODO: implement
      friends = mkOption {
        type =
          let
            peers = filterHosts (c: c.sys.hostname != config.c.sys.hostname);
          in
          types.listOf (types.enum peers);
        default = [ ];
      };
      stable = mkOption {
        type = types.bool;
        default = config.c.sys.profile == "serv";
      };
      system = mkOption {
        type = types.str;
        default = "x86_64-linux";
      };
      genericLinux = mkOption {
        type = types.bool;
        default = false;
      };
      timezone = mkOption {
        type = types.str;
        default = "Europe/Zurich";
      };
      locale = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
      };
      region = mkOption {
        type = types.str;
        default = "CH";
      }; # ISO 3166-1 country code (nextcloud)
      kbLayout = mkOption {
        type = types.str;
        default = "de_CH-latin1";
      };
      font = mkOption {
        type = types.str;
        default = "${pkgs.tamzen}/share/consolefonts/Tamzen8x16.psf";
      }; # console font
      fontPkg = mkOption {
        type = types.package;
        default = pkgs.tamzen;
      }; # console font package
      hardened = mkOption {
        type = types.bool;
        default = true;
      };
      paranoid = mkOption {
        type = types.bool;
        default = false;
      };
      paranoia = mkOption {
        type = types.enum [
          0
          1
          2
          3
        ];
        default = 0;
      };
      services = mkOption {
        type =
          let
            serviceTypes = listNixModuleNames (PATHS.M_NIXOS + /srv);
          in
          types.listOf (types.enum serviceTypes);
        default = [ ];
      };
      monitorMeDaddy = mkOption {
        type = types.bool;
        default = config.c.sys.profile == "serv";
      };
    };
    usr = {
      style = mkOption {
        type = types.bool;
        default = !config.c.usr.minimal;
      };
      browser = mkOption {
        type = types.str;
        # Print the URL instead on servers
        default = if config.c.usr.minimal then "echo" else "firefox";
      };
      username = mkOption {
        type = types.str;
        default = "omega";
      }; # username
      homeDir = mkOption {
        type = types.str;
        default = "/home/${config.c.usr.username}";
      };
      minimal = mkOption {
        type = types.bool;
        default = false;
      };
      extraBloat = mkOption {
        type = types.bool;
        default = false;
      };
      devName = mkOption {
        type = types.str;
        default = "omega-800";
      };
      devEmail = mkOption {
        type = types.str;
        default = "gshevoroshkin@gmail.com";
      };
      dotfilesDir = mkOption {
        type = types.str;
        default = "~/.dotfiles";
      };
      theme = mkOption {
        type =
          let
            themes = listDirs PATHS.THEMES;
          in
          types.enum themes;
        default = "catppuccin-mocha";
      };
      wm = mkOption {
        type = types.str;
        default = if config.c.usr.minimal then "none" else "dwm";
      };
      wmType = mkOption {
        type = types.str;
        default =
          if config.c.usr.minimal then
            "none"
          else if (config.c.usr.wm == "hyprland" || config.c.usr.wm == "sway") then
            "wayland"
          else
            "x11";
      };
      term = mkOption {
        type = types.enum [
          "alacritty"
          "kitty"
          "st"
        ];
        default = "alacritty";
      }; # Default terminal command
      font = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font Mono";
      };
      fontPkg = mkOption {
        type = types.package;
        default = pkgs.jetbrains-mono;
      }; # Console font package
      editor = mkOption {
        type = types.enum [
          "vim"
          "nvim"
        ]; # only chad editors allowed
        default = "nvim";
      };
      shell = mkOption {
        type = types.enum (
          with pkgs;
          [
            bash
            zsh
            dash
          ]
        );
        default = pkgs.bash;
      };
      termColors = mkOption {
        default = {
          c1 = "35";
          c2 = "91";
        };
        type = types.submodule {
          options = {
            c1 = mkOption {
              type = types.str;
              default = "35"; # pink
            };
            c2 = mkOption {
              type = types.str;
              default = "91"; # orange
            };
          };
        };
      };
    };
  };
}
