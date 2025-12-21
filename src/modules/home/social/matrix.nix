{
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
          settings = {
            notifications.enabled = true;
            image_preview.protocol = {
              type = if (usr.term == "kitty") then "kitty" else "halfblocks";
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
