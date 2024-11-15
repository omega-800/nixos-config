{
  usr,
  config,
  lib,
  pkgs,
  globals,
  ...
}:
let
  cfg = config.u.net.lynx;
  inherit (lib) mkOption types mkIf;
  inherit (globals.envVars) XDG_CONFIG_HOME XDG_DOWNLOAD_DIR;
in
{
  options.u.net.lynx.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable && !usr.minimal;
  };
  config = mkIf cfg.enable {
    home = {
      sessionVariables.LYNX_CFG = "${XDG_CONFIG_HOME}/lynx/lynx.cfg";
      packages = with pkgs; [ lynx ];
    };
    xdg.configFile."lynx/lynx.cfg".text = ''
      STARTFILE:https://lynx.invisible-island.net/
      HELPFILE:https://lynx.invisible-island.net/lynx_help/lynx_help_main.html
      DEFAULT_INDEX_FILE:http://scout.wisc.edu/
      MINIMAL_COMMENTS:TRUE
      COLOR:6:brightred:black
      SAVE_SPACE:${XDG_DOWNLOAD_DIR}
      VI_KEYS_ALWAYS_ON:TRUE
      DEFAULT_KEYPAD_MODE:LINKS_AND_FIELDS_ARE_NUMBERED
      DEFAULT_USER_MODE:ADVANCED
      DEFAULT_EDITOR:${usr.editor}
      SYSTEM_EDITOR:${usr.editor}
    '';

  };
}
