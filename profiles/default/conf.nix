{ lib, pkgs, ... }: 
with lib; 
{
    sys = {
        # host
        extraGrubEntries = mkDefault "";
        system = mkDefault "x86_64-linux"; # system arch
        bootMode = mkDefault "bios"; # uefi or bios
        bootMountPath = mkDefault "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = mkDefault "/dev/sda"; # device identifier for grub; only used for legacy (bios) boot mode
        genericLinux = mkDefault false;
        # default
        timezone = mkDefault "Europe/Zurich"; # select timezone
        locale = mkDefault "en_US.UTF-8"; # select locale
        kbLayout = mkDefault "de_CH-latin1"; # select keyboard layout
        font = mkDefault "${pkgs.tamzen}/share/consolefonts/Tamzen8x16.psf"; # Selected console font
        fontPkg = mkDefault pkgs.tamzen; # Console font package
        # profile
        hardened = mkDefault true;
        paranoid = mkDefault false;
    };
    usr = rec {
        username = mkDefault "omega"; # username
        homeDir = mkDefault "/home/${username}";
        # profile
        devName = mkDefault "gs2";
        devEmail = mkDefault "georgiy.shevoroshkin@inteco.ch"; 
        dotfilesDir = mkDefault "~/.dotfiles"; # absolute path of the local repo
        theme = mkDefault "catppuccin-mocha"; # selcted theme from my themes directory (./themes/)
        wm = mkDefault "dwm"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        # window manager type (hyprland or x11) translator
        wmType = if (wm == "hyprland") then "wayland" else "x11";
        browser = mkDefault "qutebrowser"; # Default browser; must select one from ./user/app/browser/
        defaultRoamDir = mkDefault "Personal.p"; # Default org roam directory relative to ~/Org
        term = mkDefault "alacritty"; # Default terminal command;
        font = mkDefault "JetBrainsMono"; # select font
        fontPkg = mkDefault pkgs.jetbrains-mono; # Console font package
        editor = mkDefault "nvim"; # Default editor;
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
    };
}
