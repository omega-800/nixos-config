{
  config,
  globals,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mapAttrs
    types
    mkIf
    ;
  cfg = config.u.social.accounts;
  pass = "${config.programs.password-store.package}/bin/pass";
in
{
  options.u.social.accounts.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    # TODO: modularize & filter
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
                realName = "Georgiy Chirokikh Shevoroshkin";
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
                passwordCommand = "${pass} services/google-aerc";
                primary = true;
              };
              /*
                proton = {
                  address = "gshevoroshkin@proton.com";
                  flavor = "plain";
                  passwordCommand = "${pass} services/proton";
                };
              */
              school = {
                address = "georgiy.shevoroshkin@ost.ch";
                flavor = "outlook.office365.com";
                passwordCommand = "${pass} school/ms-aerc";
                # passwordCommand = "${pkgs.oama}/bin/oama access georgiy.shevoroshkin@ost.ch";

                imap = {
                  host = "outlook.office365.com";
                  port = 993;
                  tls.enable = true;
                };
                smtp = {
                  host = "smtp.office365.com";
                  port = 587;
                  tls = {
                    enable = true;
                    useStartTls = true; # only STARTTLS works
                  };
                };
                aerc = rec {
                  enable = true;
                  imapAuth = "xoauth2";
                  smtpAuth = "xoauth2";

                  # see above for explanation
                  imapOauth2Params = {
                    client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
                    scope = "offline_access https://outlook.office.com/IMAP.AccessAsUser.All";
                    token_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
                  };
                  smtpOauth2Params = imapOauth2Params;

                  # https://man.sr.ht/~rjarry/aerc/providers/microsofto365.md
                  # https://gitlab.fachschaften.org/nicolas.lenz/nixos/-/blob/main/home/apps/email.nix
                  # imapOauth2Params = {
                  #   client_id = "08162f7c-0fd2-4200-a84a-f25a4db0b584";
                  #   client_secret = "TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82";
                  #   scope = "offline_access https://outlook.office.com/IMAP.AccessAsUser.All https://outlook.office.com/SMTP.Send";
                  #   token_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/token";

                  #   tenant = "common";
                  #   prompt = "select_account";
                  # };
                };
                # imap = {
                #   authentication = "xoauth2";
                #   host = "outlook.office365.com";
                #   # port = 993;
                #   tls.enable = true;
                # };
              };
            };
      };
      calendar = {
        basePath = globals.envVars.CALPATH;
        accounts = {
          # TODO:
          omega = {
            primary = true;
            remote = {
              type = "google_calendar";
              passwordCommand = [ "${pass} services/google-aerc" ];
            };
          };
          school = {
            remote = {
              type = "http";
              url = "https://unterricht.ost.ch/icalv1/Calendar/66a6d2f6-dcc9-4928-8982-c51ff7200b61#";
            };
            khal.enable = true;
            vdirsyncer.enable = true;
          };
        };
      };
    };
  };
}
