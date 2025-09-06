{ config, globals, ... }:
let
  inherit (builtins) mapAttrs;
in
{
  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };
  accounts = {
    email = {
      maildirBasePath = globals.envVars.MAILPATH;
      accounts =
        mapAttrs
          (
            _: v:
            v
            // {
              enable = true;
              aerc.enable = true;
              realName = "Georgiy Shevoroshkin";
              signature = {
                showSignature = "append";
                text = ''
                  Freundliche Grüsse 
                  Georgiy Chirokikh Shevoroshkin
                '';
              };
            }
          )
          {
            omega = {
              address = "gshevoroshkin@gmail.com";
              flavor = "gmail.com";
              # gpg.key = "";
              passwordCommand = "${config.programs.password-store.package}/bin/pass services/google-aerc";
              primary = true;
            };
            /*
              proton = {
                address = "gshevoroshkin@proton.com";
                flavor = "plain";
                passwordCommand = "${config.programs.password-store.package}/bin/pass services/proton";
              };
            */
            school = {
              address = "georgiy.shevoroshkin@ost.ch";
              flavor = "outlook.office365.com";
              passwordCommand = "${config.programs.password-store.package}/bin/pass school/edu-id";
              aerc = {
                enable = true;
                imapAuth = "xoauth2";
          # https://gitlab.fachschaften.org/nicolas.lenz/nixos/-/blob/main/home/apps/email.nix
        imapOauth2Params = {
          client_id="9e5f94bc-e8a4-4e73-b8be-63364c29d753";
          scope="offline_access https://outlook.office.com/IMAP.AccessAsUser.All";
          token_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
        };
              };
              /*
                imap = {
                  authentication = "xoauth2";
                  host = "outlook.office365.com";
                  port = 993;
                  tls.enable = true;
                };
              */
            };
          };
    };
  };
}
