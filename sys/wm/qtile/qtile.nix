{ usr, pkgs, ... }: 
let 
  qtileEnvironment = pkgs.python3.withPackages (_: with pkgs.python3Packages; [qtile qtile-extras pyyaml]);
in {
  imports = [ ../x11/x11.nix ];

  environment.systemPackages = with pkgs; [
  (writeShellScriptBin "qtile_start" ''
    #!${pkgs.bash}/bin/bash
    #[ -d $HOME/.local/share/qtile ] || mkdir $HOME/.local/share/qtile
    #[ -f $HOME/.local/share/qtile/qtile.log ] && mv $HOME/.local/share/qtile/qtile.log{,.1}
    #[ -f $HOME/.local/share/qtile/qtile.stdout ] && mv $HOME/.local/share/qtile/qtile.stdout{,.1}
    #[ -f $HOME/.local/share/qtile/qtile.stderr ] && mv $HOME/.local/share/qtile/qtile.stderr{,.1}
    ${qtileEnvironment}/bin/qtile start -b wayland 1>$HOME/.local/share/qtile/qtile.stdout 2>$HOME/.local/share/qtile/qtile.stderr
  '')
  ];

  services.xserver.windowManager.qtile = {
    enable = true;
    configFile = "/home/${usr.username}/.config/qtile/config.py";
    backend = "x11";
    extraPackages = p: with p; [
      pyyaml
      qtile-extras
    ];
  };
}
