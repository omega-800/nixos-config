{ config, globals, ... }:
let
  inherit (builtins) mapAttrs;
in
{
  programs = {
    # qcal.enable = true;
    khal = {
      enable = true;
      # settings.default.default_calendar = "school";
    };
    vdirsyncer.enable = true;
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
  services.vdirsyncer.enable = true;
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
                  client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
                  scope = "offline_access https://outlook.office.com/IMAP.AccessAsUser.All";
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
    calendar = {
      basePath = globals.envVars.CALPATH;
      accounts = {
        # TODO:
        omega = {
          primary = true;
          remote = {
            type = "google_calendar";
            passwordCommand = [ "${config.programs.password-store.package}/bin/pass services/google-aerc" ];
          };
        };
        school = {
          remote = {
            type = "http";
            url = "https://unterricht.ost.ch/icalv1/Calendar/66a6d2f6-dcc9-4928-8982-c51ff7200b61#";
          };
          # qcal.enable = true;
          khal.enable = true;
          vdirsyncer = {
            enable = true;
          };
        };
      };
    };
  };
}
