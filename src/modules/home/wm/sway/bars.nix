{
  config,
  pkgs,
  globals,
  usr,
  ...
}:
with config.lib.stylix.colors;
[
  {
    colors = {
      background = "#${base00}";
      focusedBackground = "#${base01}";
      separator = "#${base04}";
      focusedSeparator = "#${base06}";
      statusline = "#${base04}";
      focusedStatusline = "#${base06}";
      focusedWorkspace = {
        background = "#${base03}";
        border = "#${base03}";
        text = "#${base07}";
      };
      activeWorkspace = {
        background = "#${base02}";
        border = "#${base02}";
        text = "#${base07}";
      };
      inactiveWorkspace = {
        background = "#${base01}";
        border = "#${base01}";
        text = "#${base06}";
      };
      urgentWorkspace = {
        background = "#${base0E}";
        border = "#${base0E}";
        text = "#${base00}";
      };
      bindingMode = {
        background = "#${base0D}";
        border = "#${base0D}";
        text = "#${base00}";
      };
    };
    fonts = {
      # names = [ "JetBrainsMono Nerd Font" ];
      names = [ usr.font ];
      style = "Mono";
      size = 12.0;
    };
    id = "primary";
    position = "top";
    trayOutput = "*";
    # command = "${pkgs.sway}/bin/swaybar";
    # command = "${pkgs.waybar}/bin/waybar";
    # command = "i3bar";
    statusCommand = "${pkgs.i3status}/bin/i3status"; # ${globals.envVars.XDG_CONFIG_HOME}/i3status-rust/config-default.toml";
  }
]
