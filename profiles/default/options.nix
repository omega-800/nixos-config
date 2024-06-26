{ config, lib, pkgs, ... }: 
with lib; 
{
  options.c = {
    sys = {
        hostname = mkOption {
					type = types.str;
					default = "nixie";
				}; # hostname
        profile = mkOption {
					type = types.str;
					default = "pers";
				}; # select a profile defined from my profiles directory
        system = mkOption {
					type = types.str;
					default = "x86_64-linux";
				}; # system arch
        genericLinux = mkOption {
					type = types.bool;
					default = false;
				};
        # host
        authorizedSshKeys = mkOption {
					type = types.listOf types.str;
					default = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBG4vyC8dYQEEv7JUeWmHqeKNBrB/GmV4sXED4dkhT2u omega@archie" ];
				};
        extraGrubEntries = mkOption {
					type = types.str;
					default = "";
				};
        bootMode = mkOption {
					type = types.str;
					default = "uefi";
				}; # uefi or bios
        bootMountPath = mkOption {
					type = types.str;
					default = "/boot";
				}; # mount path for efi boot partition: only used for uefi boot mode
        grubDevice = mkOption {
					type = types.str;
					default = "/dev/sda";
				}; # device identifier for grub: only used for legacy (bios) boot mode
        timezone = mkOption {
					type = types.str;
					default = "Europe/Zurich";
				}; # select timezone
        locale = mkOption {
					type = types.str;
					default = "en_US.UTF-8";
				}; # select locale
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
    };
    usr = {
        style = mkOption {
					type = types.bool;
					default = true;
				};
        username = mkOption {
					type = types.str;
					default = "omega";
				}; # username
        homeDir = mkOption {
					type = types.str;
					default = "/home/${config.c.usr.username}";
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
				}; # selcted theme from my themes directory (./themes/)
        wm = mkOption {
					type = types.str;
					default = "dwm";
				}; # Selected window manager or desktop environment: must select one in both ./user/wm/ and ./system/wm/
        # window manager type (hyprland or x11) translator
        wmType = mkOption {
					type = types.str;
					default = if (config.c.usr.wm == "hyprland") then "wayland" else "x11";
				};
        browser = mkOption {
					type = types.str;
					default = "qutebrowser";
				};
        term = mkOption {
					type = types.str;
					default = "alacritty";
				}; # Default terminal command
        font = mkOption {
					type = types.str;
					default = "JetBrainsMono Nerd Font Mono";
				}; # select font
        fontPkg = mkOption {
					type = types.package;
					default = pkgs.jetbrains-mono;
				}; # Console font package
        editor = mkOption {
					type = types.str;
					default = "nvim";
				}; # Default editor
        shell = mkOption {
					type = types.package;
					default = pkgs.bash;
				};
    };
  };
}
