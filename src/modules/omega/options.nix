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
  inherit (lib) mkOption isString;
  inherit (lib.types)
    ints
    str
    listOf
    either
    enum
    nullOr
    addCheck
    bool
    package
    submodule
    ;
  inherit (builtins) length elem;
in
{
  options.c = {
    net = {
      id = mkOption {
        type = ints.between 2 254;
        default = 100;
        description = "host id (last part of ipv4 addr)";
      };
      pubkeys = mkOption {
        type = listOf str;
        default = [ ];
        description = "public ssh key(s)";
      };
      identityFile = mkOption {
        type = str;
        default = "~/.ssh/id_ed25519";
        description = "private ssh key file";
      };
      # TODO: networks as their own entities
      network = mkOption {
        description = "network";
        type = addCheck (either str (listOf (ints.between 0 255))) (
          x: (isString x && x == "dynamic") || (length x == 3)
        );
        default =
          if config.c.sys.profile == "serv" then
            [
              10
              0
              0
            ]
          else
            "dynamic";
      };
      prefix = mkOption {
        description = "network prefix length";
        type = nullOr (ints.between 1 32);
        default = if config.c.sys.profile == "serv" then 24 else null;
      };
      domain = mkOption {
        description = "domain";
        type = str;
        default = "home.lan";
      };
      hostname = mkOption {
        type = str;
        default = "nixie";
      }; # will be set to the dirname of the host configs
      #TODO: implement
      friends = mkOption {
        type =
          let
            peers = filterHosts (c: c.net.hostname != config.c.net.hostname);
          in
          listOf (enum peers);
        default = [ ];
      };
    };
    sys = {
      profile =
        let
          profiles = listFilterDirs (
            n: v:
            !(elem n [
              "default"
              "partials"
            ])
          ) PATHS.PROFILES;
        in
        mkOption {
          type = enum profiles;
          default = "pers";
        }; # select a profile defined from my profiles directory
      #TODO: implement
      flavors = mkOption {
        type = listOf (enum [
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
        ]);
        default = [ ];
      };
      stable = mkOption {
        type = bool;
        default = config.c.sys.profile == "serv";
      };
      system = mkOption {
        type = str;
        default = "x86_64-linux";
      };
      genericLinux = mkOption {
        type = bool;
        default = false;
      };
      timezone = mkOption {
        type = str;
        default = "Europe/Zurich";
      };
      locale = mkOption {
        type = str;
        default = "en_US.UTF-8";
      };
      region = mkOption {
        type = str;
        default = "CH";
      }; # ISO 3166-1 country code (nextcloud)
      kbLayout = mkOption {
        type = str;
        default = "de_CH-latin1";
      };
      font = mkOption {
        type = str;
        default = "${pkgs.tamzen}/share/consolefonts/Tamzen8x16.psf";
      }; # console font
      fontPkg = mkOption {
        type = package;
        default = pkgs.tamzen;
      }; # console font package
      hardened = mkOption {
        type = bool;
        default = true;
      };
      paranoid = mkOption {
        type = bool;
        default = false;
      };
      # TODO: switch to lonsdaleite
      paranoia = mkOption {
        type = enum [
          0
          1
          2
          3
        ];
        default = 0;
      };
      monitorMeDaddy = mkOption {
        type = bool;
        default = config.c.sys.profile == "serv";
      };
    };
    usr = {
      style = mkOption {
        type = bool;
        default = !config.c.usr.minimal;
      };
      browser = mkOption {
        type = str;
        # Print the URL instead on servers
        default = if config.c.usr.minimal then "echo" else "firefox";
      };
      username = mkOption {
        type = str;
        default = "omega";
      }; # username
      homeDir = mkOption {
        type = str;
        default = "/home/${config.c.usr.username}";
      };
      minimal = mkOption {
        type = bool;
        default = false;
      };
      extraBloat = mkOption {
        type = bool;
        default = false;
      };
      devName = mkOption {
        type = str;
        default = "omega-800";
      };
      devEmail = mkOption {
        type = str;
        default = "gshevoroshkin@gmail.com";
      };
      dotfilesDir = mkOption {
        type = str;
        default = "~/.dotfiles";
      };
      theme = mkOption {
        type =
          let
            themes = listDirs PATHS.THEMES;
          in
          enum themes;
        default = "catppuccin-mocha";
      };
      wm = mkOption {
        type = str;
        default = if config.c.usr.minimal then "none" else "dwm";
      };
      wmType = mkOption {
        type = str;
        default =
          if config.c.usr.minimal then
            "none"
          else if
            (elem config.c.usr.wm [
              "hyprland"
              "sway"
              "river"
            ])
          then
            "wayland"
          else
            "x11";
      };
      term = mkOption {
        type = enum [
          "alacritty"
          "kitty"
          "st"
        ];
        default = "alacritty";
      }; # Default terminal command
      font = mkOption {
        type = str;
        default = "JetBrainsMono";
      };
      fontPkg = mkOption {
        type = package;
        default = pkgs.nerd-fonts.jetbrains-mono;
      }; # Console font package
      editor = mkOption {
        type = enum [
          "vim"
          "nvim"
        ]; # only chad editors allowed
        default = "nvim";
      };
      shell = mkOption {
        type = enum (
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
        type = submodule {
          options = {
            c1 = mkOption {
              type = str;
              default = "35"; # pink
            };
            c2 = mkOption {
              type = str;
              default = "91"; # orange
            };
          };
        };
      };
    };
  };
}
