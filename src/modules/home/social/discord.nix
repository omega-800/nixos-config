{
  inputs,
  config,
  lib,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.social.discord;
in
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  options.u.social.discord.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable && usr.extraBloat;
  };
  config = mkIf cfg.enable {
    # nixpkgs.config.allowUnfreePredicate = p: builtins.elem (getName p) [ "discord" ];
    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      # dorion.enable = true;
      config = {
        frameless = true;
        plugins = {
          anonymiseFileNames = {
            enable = true;
            anonymiseByDefault = true;
          };
          ctrlEnterSend.enable = true;
          ignoreActivities = {
            enable = true;
            ignorePlaying = true;
            ignoreWatching = true;
          };
        };
      };
      dorion = {
        blur = "acrylic";
        sysTray = true;
        openOnStartup = true;
        autoClearCache = true;
        disableHardwareAccel = false;
        rpcServer = true;
        rpcProcessScanner = true;
        pushToTalk = true;
        pushToTalkKeys = [ "RControl" ];
        desktopNotifications = true;
        unreadBadge = true;
      };
    };
  };
}
