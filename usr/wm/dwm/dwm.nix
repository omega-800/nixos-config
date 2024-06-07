{ lib, config, home, pkgs, userSettings, ... }: 
let 
  dwm_stats = pkgs.writeShellScript "dwm_stats" ./dwm_stats.sh; 
  customSt = pkgs.st.overrideAttrs {
      src = builtins.fetchGit {
        url = "https://github.com/omega-800/st.git"; 
        ref = "main";
        rev = "f339235f5c99e02c88fd54ac6a2f3827d120480d";
      };
  };
in {
  home = {
    packages = with pkgs; [ customSt ];
    file.".xinitrc".text = ''
#setxkbmap -layout ch -variant de 
sxhkd &
xrandr
xrdb ~/.Xresources
xset -b

udiskie &
ibus-daemon -rxRd
unclutter --jitter 10 --ignore-scrolling --start-hidden --fork
picom &
/home/omega/.fehbg-stylix
${dwm_stats} &
systemctl --user import-environment DISPLAY
redshift -O3500; xset r rate 300 50; exec dbus-launch dwm
    '';
    #activation.copyMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
    /*file.".Xresources".text = ''
dwm.font: ${userSettings.font}
dwm.dmenufont: ${userSettings.font}
dwm.normbgcolor: #${config.lib.stylix.colors.base03}
dwm.normbordercolor: #${config.lib.stylix.colors.base07}
dwm.normfgcolor: #${config.lib.stylix.colors.base00}
dwm.selfgcolor: #${config.lib.stylix.colors.base05}
dwm.selbordercolor: #${config.lib.stylix.colors.base0B}
dwm.warnfggcolor: #${config.lib.stylix.colors.base0A}
dwm.warnbggcolor: #${config.lib.stylix.colors.base0E}
dwm.urgbgcolor: #${config.lib.stylix.colors.base09}
dwm.urgfggcolor: #${config.lib.stylix.colors.base00}

*font: ${userSettings.font}
*color0: #${config.lib.stylix.colors.base00}
*color1: #${config.lib.stylix.colors.base01}
*color2: #${config.lib.stylix.colors.base02}
*color3: #${config.lib.stylix.colors.base03}
*color4: #${config.lib.stylix.colors.base04}
*color5: #${config.lib.stylix.colors.base05}
*color6: #${config.lib.stylix.colors.base06}
*color7: #${config.lib.stylix.colors.base07}
*color8: #${config.lib.stylix.colors.base08}
*color9: #${config.lib.stylix.colors.base09}
*color10: #${config.lib.stylix.colors.base0A}
*color11: #${config.lib.stylix.colors.base0B}
*color12: #${config.lib.stylix.colors.base0C}
*color13: #${config.lib.stylix.colors.base0D}
*color14: #${config.lib.stylix.colors.base0E}
*color15: #${config.lib.stylix.colors.base0F}
*background: #${config.lib.stylix.colors.base00}
*foreground: #${config.lib.stylix.colors.base07}
*cursorColor: #${config.lib.stylix.colors.base07}

*.faceName: ${userSettings.font}
*.faceSize: 32
*.renderFont: true
Sxiv.background: #${config.lib.stylix.colors.base0C}
Sxiv.foreground: #${config.lib.stylix.colors.base0A}
Sxiv.font: ${userSettings.font}-12
Xcursor.theme: Bibata-Modern-Ice
Xcursor.size: 32
    '';*/
  };

#  services.dwm-status = {
#    enable = true;
#    order = [ "cpu_load" "network" "backlight" "audio" "battery" "time" ];
#    extraConfig = {
#      battery = {
#        notifier_levels = [ 2 5 10 15 20 25 30 ];
#      };
#    };
#  };
}
