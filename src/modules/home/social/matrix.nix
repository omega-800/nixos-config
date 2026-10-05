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
          profiles = {
            personal.user_id = "@omega-800:matrix.org";
            school.user_id = "@omega:open-ost.ch";
          };
          dirs.downloads = "${globals.envVars.XDG_DOWNLOAD_DIR}/iamb";
          settings = {
            notifications = {
              enabled = true;
              via = "desktop|bell";
            };
            open_command = [ "xdg-open" ];
            image_preview.protocol = {
              type = if (usr.term == "kitty" || usr.term == "ghostty") then "kitty" else "halfblocks";
              size = {
                height = 10;
                width = 66;
              };
            };
            layout.style = "new";
            aliases = {
              "c" = "chats";
              "m" = "rooms";
              "r" = "reply";
              "d" = "download";
              "e" = "edit";
              "o" = "open";
              "u" = "upload";
            };
            macros = {
              "normal|visual" = {
                "V" = "<C-W>m";
              };
            };
          };
        };
      };
    };
  };
}
