
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
  cfg = config.u.social.mail.dodo;
in
{
  options.u.social.mail.dodo.enable = mkOption {
    type = types.bool;
    default = config.u.social.mail.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ dodo ];
    programs.offlineimap.enable = true;

    xdg.configFile."dodo/config.py".text = ''
      import dodo
      '';

    #   dodo.settings.smtp_accounts = [ ${
    #     concatMapStringsSep ", " (n: "'${n}'") (attrNames config.accounts.email.accounts)
    #   } ]
    #   # TODO: v.userName
    #   dodo.settings.email_address = { ${
    #     concatMapAttrsStringSep ", " (
    #       n: v: "'${n}': '${v.realName} <${v.address}>'"
    #     ) config.accounts.email.accounts
    #   } }
    #   # TODO: check how other mail clients are configured
    #   dodo.settings.sent_dir = { ${
    #     concatMapAttrsStringSep ", " (
    #       n: v: "'${n}': '${config.accounts.email.maildirBasePath}/${v.folders.sent}>'"
    #     ) config.accounts.email.accounts
    #   } }
    #
    #   # TODO: stylix
    #   dodo.settings.theme = dodo.themes.catppuccin_macchiato
    #   dodo.util.html2html = dodo.util.clean_html2html
    #   dodo.settings.editor_command = "${usr.term} nvim '{file}'"
    #   dodo.settings.file_browser_command = "${usr.term} yazi '{dir}'"
    #   # TODO: more configs
    # '';

  };
}
