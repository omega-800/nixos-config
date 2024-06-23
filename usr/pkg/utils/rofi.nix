{ config, lib, usr, pkgs, ... }: with lib; {
  programs.rofi = mkIf config.u.utils.enable {
    enable = true;
    cycle = false;
    extraConfig = {
      modi = "drun,ssh,window,run";
    };
    font = "${usr.font} 12";
    location = "center";
    pass = {
      enable = true;
      stores = [ "~/.password-store" ];
    };
    plugins = with pkgs; [
      rofi-calc
      rofi-mpd
      rofi-systemd
    ] ++ (if usr.extraBloat then with pkgs; [
      rofimoji
      rofi-vpn
      rofi-top
      rofi-menugen
      rofi-obsidian
      rofi-screenshot
      rofi-power-menu
      rofi-file-browser
      rofi-pulse-select
    ] else []);
    terminal = "${pkgs.alacritty}/bin/alacritty";

    /*
    theme = ''
* {
    background:     #${config.lib.stylix.colors.base00};
    background-alt: #${config.lib.stylix.colors.base03};
    foreground:     #${config.lib.stylix.colors.base07};
    selected:       #${config.lib.stylix.colors.base0E};
    active:         #${config.lib.stylix.colors.base0B};
    urgent:         #${config.lib.stylix.colors.base09};
    font:           "${usr.font}";
}

configuration {
	modi:                       "drun";
    show-icons:                 true;
    display-drun:               "";
	drun-display-format:        "{name}";
}

window {
    transparency:                "real";
    location:                    center;
    anchor:                      center;
    fullscreen:                  false;
    width:                       400px;
    x-offset:                    0px;
    y-offset:                    0px;

    enabled:                     true;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               12px;
    border-color:                @selected;
    background-color:            @background;
    cursor:                      "default";
}

mainbox {
    enabled:                     true;
    spacing:                     0px;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               0px 0px 0px 0px;
    border-color:                @selected;
    background-color:            transparent;
    children:                    [ "inputbar", "listview" ];
}

inputbar {
    enabled:                     true;
    spacing:                     10px;
    margin:                      0px;
    padding:                     15px;
    border:                      0px solid;
    border-radius:               0px;
    border-color:                @selected;
    background-color:            @selected;
    text-color:                  @background;
    children:                    [ "prompt", "entry" ];
}

prompt {
    enabled:                     true;
    background-color:            inherit;
    text-color:                  inherit;
}
textbox-prompt-colon {
    enabled:                     true;
    expand:                      false;
    str:                         "::";
    background-color:            inherit;
    text-color:                  inherit;
}
entry {
    enabled:                     true;
    background-color:            inherit;
    text-color:                  inherit;
    cursor:                      text;
    placeholder:                 "Search...";
    placeholder-color:           inherit;
}

listview {
    enabled:                     true;
    columns:                     1;
    lines:                       6;
    cycle:                       true;
    dynamic:                     true;
    scrollbar:                   false;
    layout:                      vertical;
    reverse:                     false;
    fixed-height:                true;
    fixed-columns:               true;
    
    spacing:                     5px;
    margin:                      0px;
    padding:                     0px;
    border:                      0px solid;
    border-radius:               0px;
    border-color:                @selected;
    background-color:            transparent;
    text-color:                  @foreground;
    cursor:                      "default";
}
scrollbar {
    handle-width:                5px ;
    handle-color:                @selected;
    border-radius:               0px;
    background-color:            @background-alt;
}

element {
    enabled:                     true;
    spacing:                     10px;
    margin:                      0px;
    padding:                     8px;
    border:                      0px solid;
    border-radius:               0px;
    border-color:                @selected;
    background-color:            transparent;
    text-color:                  @foreground;
    cursor:                      pointer;
}
element normal.normal {
    background-color:            @background;
    text-color:                  @foreground;
}
element selected.normal {
    background-color:            @background-alt;
    text-color:                  @foreground;
}
element-icon {
    background-color:            transparent;
    text-color:                  inherit;
    size:                        32px;
    cursor:                      inherit;
}
element-text {
    background-color:            transparent;
    text-color:                  inherit;
    highlight:                   inherit;
    cursor:                      inherit;
    vertical-align:              0.5;
    horizontal-align:            0.0;
}

error-message {
    padding:                     15px;
    border:                      2px solid;
    border-radius:               12px;
    border-color:                @selected;
    background-color:            @background;
    text-color:                  @foreground;
}
textbox {
    background-color:            @background;
    text-color:                  @foreground;
    vertical-align:              0.5;
    horizontal-align:            0.0;
    highlight:                   none;
}
    '';
    */
  };
}
