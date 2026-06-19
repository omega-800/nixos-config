{
  globals,
  config,
  usr,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.social.matrix;
in
{
  options.u.social.matrix.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    programs = {
      iamb = {
        enable = true;
        settings = {
          default_profile = "personal";
          profiles.personal.user_id = "@omega-800:matrix.org";
          dirs.downloads = "${globals.envVars.XDG_DOWNLOAD_DIR}/iamb";
          settings = {
            notifications.enabled = true;
            open_command = [ "xdg-open" ];
            image_preview.protocol = {
              type = if (usr.term == "kitty" || usr.term == "ghostty") then "kitty" else "halfblocks";
              size = {
                height = 10;
                width = 66;
              };
            };
          };
        };
      };
    };
  };
}
