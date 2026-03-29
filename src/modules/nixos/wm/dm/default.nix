{
  inputs,
  config,
  sys,
  lib,
  pkgs,
  usr,
  ...
}:
let
  cfg = config.m.wm.dm;
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
  cmd =
    if usr.wmType == "x11" then
      "startx"
    else
      # audible confusion
      # "lxqt-policykit-agent " +
      (if usr.wm == "hyprland" then "Hyprland" else usr.wm);
in
{
  options.m.wm.dm = {
    enable = mkOption {
      description = "enables dm";
      type = types.bool;
      default = usr.wm != "none";
    };
  };
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # TODO: fix & config colors
          # command = ''
          #   ${pkgs.tuigreet}/bin/tuigreet --cmd ${cmd} \
          #     --time --time-format '%H:%M | %A - %B | %F' \
          #     --asterisk --asterisks-char '%&*#?=$@' \
          #     --theme 'border=magenta;text=blue;prompt=blue;time=magenta;action=magenta;button=blue;container=black;input=red' \
          #     --window-padding 4 --container-padding 4 --prompt-padding 4 \ 
          #     --issue 
          # '';
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd ${cmd} --time --time-format '%H:%M | %a | %h | %F'";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = with pkgs; [ tuigreet ];
    # failed attempt at solution below
    # boot.kernel.sysctl = { "kernel.printk" = "3 3 3 3"; };
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
