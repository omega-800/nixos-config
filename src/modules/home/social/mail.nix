{
  config,
  pkgs,
  lib,
  usr,
  ...
}:
let
  inherit (lib)
    concatMapAttrsStringSep
    concatMapStringsSep
    attrNames
    mkOption
    types
    mkIf
    ;
  cfg = config.u.social.mail;
in
{
  options.u.social.mail.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    /*
      # for microsoft o365
      home.packages = [ pkgs.oama ];
      xdg.configFile."oama/config.yaml".text = ''
        encryption:
            tag: KEYRING

        services:
          microsoft:
            ## thunderbird client values
            client_id: 08162f7c-0fd2-4200-a84a-f25a4db0b584
            client_secret: 'TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82'
            auth_scope: https://outlook.office.com/IMAP.AccessAsUser.All
              https://outlook.office.com/SMTP.Send
              offline_access
            tenant: common
            prompt: select_account
      '';
    */

    # nixpkgs.config.permittedInsecurePackages = [
    #   "python-2.7.18.12"
    # ];
    # home.packages = with pkgs; [ dodo ];
    xdg.configFile."dodo/config.py".text = ''
      import dodo

      dodo.settings.smtp_accounts = [ ${
        concatMapStringsSep ", " (n: "'${n}'") (attrNames config.accounts.email.accounts)
      } ]
      # TODO: v.userName
      dodo.settings.email_address = { ${
        concatMapAttrsStringSep ", " (
          n: v: "'${n}': '${v.realName} <${v.address}>'"
        ) config.accounts.email.accounts
      } }
      # TODO: check how other mail clients are configured
      dodo.settings.sent_dir = { ${
        concatMapAttrsStringSep ", " (
          n: v: "'${n}': '${config.accounts.email.maildirBasePath}/${v.folders.sent}>'"
        ) config.accounts.email.accounts
      } }

      # TODO: stylix
      dodo.settings.theme = dodo.themes.catppuccin_macchiato
      dodo.util.html2html = dodo.util.clean_html2html
      dodo.settings.editor_command = "${usr.term} nvim '{file}'"
      dodo.settings.file_browser_command = "${usr.term} yazi '{dir}'"
      # TODO: more configs
    '';

    programs = {
      aerc = {
        enable = true;
        # extraBinds.messages.q = ":quit<Enter>";
        extraConfig = {
          general.unsafe-accounts-conf = true;
          filters = {
            "text/plain" = "colorize";
            # "text/calendar" = "calendar";
            # "message/delivery-status" = "colorize";
            # "message/rfc822" = "colorize";
            # "text/html" = "html | colorize";
            # "text/*" = ''bat -fP --file-name="$AERC_FILENAME"'';
            # ".headers" = "colorize";
          };
        };
      };
    };
  };
}
