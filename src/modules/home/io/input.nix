{
  pkgs,
  lib,
  usr,
  config,
  ...
}:
let
  cfg = config.u.io.fcitx5;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.u.io.fcitx5.enable = mkEnableOption "fcitx5";
  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        # TODO: quickPhrase
        # TODO: PreeditInApplication=True
        addons = with pkgs; [
          fcitx5-mozc
          qt6Packages.fcitx5-chinese-addons
          fcitx5-material-color
        ];
        waylandFrontend = usr.wmType == "wayland";
        settings = {
          addons = {
            classicui.globalSection = {
              # FIXME: stylix kinda borked
              Theme = lib.mkForce "Material-Color-Black";
              PerScreenDPI = false;
            };
            pinyin.globalSection = {
              CloudPinyinEnabled = false;
              PreeditInApplication = true;
            };
            mozc.globalSection = {
              PreeditInApplication = true;
            };
          };
          globalOptions = {
            Hotkey = {
              "TriggerKeys" = "0=Control+i";
              "EnumerateGroupForwardKeys" = "0=Control+Shift+i";
              "EnumerateGroupBackwardKeys" = "0=Control+Shift+o";
              EnumerateWithTriggerKeys = true;
            };
          };
          inputMethod = {
            GroupOrder = {
              "0" = "Swiss";
              "1" = "Japanese";
              "2" = "Russian";
              "3" = "English";
              "4" = "Chinese";
            };

            "Groups/0" = {
              Name = "Swiss";
              "Default Layout" = "ch";
              DefaultIM = "keyboard-ch";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-ch";
              Layout = "ch";
            };

            "Groups/1" = {
              Name = "Japanese";
              "Default Layout" = "jp";
              DefaultIM = "mozc";
            };
            "Groups/1/Items/0" = {
              Name = "mozc";
            };
            "Groups/1/Items/1" = {
              Name = "keyboard-jp";
            };
            "Groups/1/Items/2" = {
              Layout = "ch";
              Name = "keyboard-ch";
            };

            "Groups/2" = {
              Name = "Russian";
              "Default Layout" = "ru";
              DefaultIM = "keyboard-ru";
            };
            "Groups/2/Items/0" = {
              Name = "keyboard-ru";
            };
            "Groups/2/Items/1" = {
              Layout = "ch";
              Name = "keyboard-ch";
            };

            "Groups/3" = {
              Name = "English";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/3/Items/0" = {
              Name = "keyboard-us";
            };
            "Groups/3/Items/1" = {
              Layout = "ch";
              Name = "keyboard-ch";
            };

            "Groups/4" = {
              Name = "Chinese";
              "Default Layout" = "cn";
              DefaultIM = "pinyin";
            };
            "Groups/4/Items/0" = {
              Name = "pinyin";
            };
            "Groups/4/Items/1" = {
              Name = "keyboard-cn";
            };
            "Groups/4/Items/2" = {
              Layout = "ch";
              Name = "keyboard-ch";
            };
          };
        };
      };
    };
  };
}
