{
  config,
  lib,
  ...
}:
let
  cfg = config.m.srv.postfix;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.srv.postfix.enable = mkEnableOption "postfix";
  config = mkIf cfg.enable {
    services.postfix = {
      enable = true;
      # TODO:
      enableHeaderChecks = true;
      enableSmtp = true;
      setSendmail = true;
      localRecipients = [ "@home.lan" ];
    };
  };
}
