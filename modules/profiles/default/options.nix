{ config, lib, pkgs, ... }:
let
  # kind of a hacky workaround but if it works then it works
  inherit (import ../../lib/my/dirs.nix { inherit lib; })
    listNixModuleNames listFilterDirs;
  inherit (lib) mkOption types;
in {
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
      profile = let
        profiles =
          listFilterDirs (n: v: !(builtins.elem n [ "default" "partials" ]))
          ../.;
      in mkOption {
        type = types.enum profiles;
        default = "pers";
      }; # select a profile defined from my profiles directory
      #TODO: implement
      flavors = mkOption {
        type = types.listOf (types.enum [
          "builder"
          "developer"
          "master"
          "slave"
          "worker"
          "storer"
          "hoster"
          "parent"
          "child"
        ]);
        default = [ ];
      };
      stable = mkOption {
        type = types.bool;
        default = config.c.sys.profile == "serv";
      };
      system = mkOption {
        type = types.str;
        default = "x86_64-linux";
      }; # system arch
      genericLinux = mkOption {
        type = types.bool;
        default = false;
      };
      timezone = mkOption {
        type = types.str;
        default = "Europe/Zurich";
      }; # select timezone
      locale = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
      }; # select locale
      region = mkOption {
        type = types.str;
        default = "CH";
      }; # ISO 3166-1 country code (nextcloud)
      kbLayout = mkOption {
        type = types.str;
        default = "de_CH-latin1";
      }; # select keyboard layout
      font = mkOption {
        type = types.str;
        default = "${pkgs.tamzen}/share/consolefonts/Tamzen8x16.psf";
      }; # Selected console font
      fontPkg = mkOption {
        type = types.package;
        default = pkgs.tamzen;
      }; # Console font package
      hardened = mkOption {
        type = types.bool;
        default = true;
      };
      paranoid = mkOption {
        type = types.bool;
        default = false;
      };
      paranoia = mkOption {
        type = types.enum [ 0 1 2 3 ];
        default = 0;
      };
      services = mkOption {
        type = let serviceTypes = listNixModuleNames ../../sys/srv;
        in types.listOf (types.enum serviceTypes);
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
      }; # absolute path of the local repo
      theme = mkOption {
        type = types.str;
        default = "catppuccin-mocha";
      }; # selected theme from my themes directory (./themes/)
      wm = mkOption {
        type = types.str;
        default = if config.c.usr.minimal then "none" else "dwm";
      }; # Selected window manager or desktop environment: must select one in both ./user/wm/ and ./system/wm/
      # window manager type (hyprland or x11) translator
      wmType = mkOption {
        type = types.str;
        default = if config.c.usr.minimal then
          "none"
        else if (config.c.usr.wm == "hyprland" || config.c.usr.wm
          == "sway") then
          "wayland"
        else
          "x11";
      };
      term = mkOption {
        type = types.enum [ "alacritty" "kitty" "st" ];
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
        type = types.enum [ "vim" "nvim" ]; # only chad editors allowed
        default = "nvim";
      };
      shell = mkOption {
        type = types.enum (with pkgs; [ bash zsh dash ]);
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
