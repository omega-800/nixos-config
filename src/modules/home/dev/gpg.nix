{
  lib,
  config,
  pkgs,
  globals,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.u.dev;
  # pinentry = pkgs.pinentry-tty;
  pinentry = pkgs.pinentry-qt;
in
{
  config = mkIf cfg.enable {
    home.packages = [ pinentry ];
    programs.gpg = {
      enable = true;
      homedir = globals.envVars.GNUPGHOME;
    };
    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      # TODO:
      enableSshSupport = false;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      maxCacheTtl = 3600;
      maxCacheTtlSsh = 3600;
      # extraConfig = ''
      #   allow-loopback-pinentry
      # '';
      pinentry.package = pinentry;
      grabKeyboardAndMouse = true;
    };
    # services.gnome-keyring = {
    #   enable = true;
    #   components = [ "ssh" "secrets" ];
    # };
  };
}
