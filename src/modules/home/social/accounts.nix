{
  config,
  globals,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkOption
    mapAttrs
    types
    mkIf
    ;
  cfg = config.u.social.accounts;
  pass = p: "${config.programs.password-store.package}/bin/pass ${p} | head -n 1";
  hostpoint = {
    flavor = "plain";
    imap = {
      authentication = "plain";
      host = "imap.mail.hostpoint.ch";
      # port = 143; # 993
      port = 993;
    };
    smtp = {
      authentication = "plain";
      host = "asmtp.mail.hostpoint.ch";
      # port = 587; # 465
      port = 465;
    };
  };
in
{
  options.u.social.accounts.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    # TODO: modularize & filter
    accounts = {
      contact.basePath = globals.envVars.CONTACTPATH;
      email = {
        maildirBasePath = globals.envVars.MAILPATH;
        accounts =
          mapAttrs
            (
              _: v:
              mkMerge [
                v
                {
                  enable = true;
                  aerc.enable = true;
                  signature.showSignature = "append";
                  # dodo
                  # FIXME: fucks aerc up if no config present
                  notmuch.enable = config.u.social.mail.dodo.enable;
                  offlineimap.enable = config.u.social.mail.dodo.enable;
                  # dodo
                }
              ]
            )
            (
              {
                oss_meetup =
                  let
                    def = {
                      authentication = "plain";
                      host = "disroot.org";
                    };
                    userName = "oss_meetup";
                  in
                  {
                    inherit userName;
                    address = "${userName}@${def.host}";
                    realName = "OSS Meetup Rapperswil";
                    passwordCommand = pass "openost/oss-meetup/oss_meetup@getgoogleoff.me";

                    signature.text = ''
                      Happy Hacking!
                      OSS Meetup Rapperswil
                    '';
                    imap = def // {
                      port = 993;
                    };
                    smtp = def // {
                      port = 465;
                    };
                  };
              }
              // (mapAttrs
                (
                  _: v:
                  mkMerge [
                    v
                    {
                      realName = "Georgiy Chirokikh Shevoroshkin";

                      signature.text = ''
                        Freundliche Grüsse 
                        Georgiy Chirokikh Shevoroshkin
                      '';
                    }
                  ]
                )
                {
                  omega = {
                    address = "gshevoroshkin@gmail.com";
                    flavor = "gmail.com";
                    passwordCommand = pass "services/google-aerc";
                    primary = true;
                  };

                  studentenportal = hostpoint // {
                    userName = "team@studentenportal.ch";
                    address = "team@studentenportal.ch";
                    passwordCommand = pass "studentenportal/email/team@studentenportal.ch";
                  };

                  open_ost = hostpoint // {
                    userName = "info@open-ost.ch";
                    address = "info@open-ost.ch";
                    passwordCommand = pass "openost/email/info@open-ost.ch";
                  };
                  /*
                    proton = {
                      address = "gshevoroshkin@proton.com";
                      flavor = "plain";
                      passwordCommand = pass "services/proton";
                    };
                  */
                  school = {
                    address = "georgiy.shevoroshkin@ost.ch";
                    flavor = "outlook.office365.com";
                    passwordCommand = pass "school/ms-aerc";
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
                    aerc =
                      let

                        tenant = "a6e70fa3-1c7a-4aa2-a25e-836eea52ca22";
                        id = "84992ecd-5239-426a-8013-b66401e8c778";
                        url = "https://outlook.office365.com/EWS/Exchange.asmx";
                        forward = "https://login.microsoftonline.com/common/oauth2/nativeclient";

                        imapOauth2Params = {
                          client_id = "08162f7c-0fd2-4200-a84a-f25a4db0b584";
                          scope = "offline_access https://outlook.office.com/IMAP.AccessAsUser.All https://outlook.office.com/SMTP.Send";
                          token_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
                        };
                        oauth2ms = "${pkgs.oauth2ms}/bin/oauth2ms";
                      in
                      {
                        enable = true;

                        # extraConfig = {
                        #   source-cred-cmd = oauth2ms;
                        #   outgoing-cred-cmd = oauth2ms;
                        # };

                        imapAuth = "xoauth2";
                        smtpAuth = "xoauth2";
                        inherit imapOauth2Params;
                        #
                        # # see above for explanation
                        smtpOauth2Params = imapOauth2Params;
                        #
                        # # https://man.sr.ht/~rjarry/aerc/providers/microsofto365.md
                        # # https://gitlab.fachschaften.org/nicolas.lenz/nixos/-/blob/main/home/apps/email.nix
                        # # imapOauth2Params = {
                        # #   client_id = "08162f7c-0fd2-4200-a84a-f25a4db0b584";
                        # #   client_secret = "TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82";
                        # #   scope = "offline_access https://outlook.office.com/IMAP.AccessAsUser.All https://outlook.office.com/SMTP.Send";
                        # #   token_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/token";
                        #
                        # #   tenant = "common";
                        # #   prompt = "select_account";
                        # # };
                      };
                    # imap = {
                    #   authentication = "xoauth2";
                    #   host = "outlook.office365.com";
                    #   # port = 993;
                    #   tls.enable = true;
                    # };
                  };
                }
              )
            );
      };
      calendar = {
        basePath = globals.envVars.CALPATH;
        accounts = {
          # TODO:
          omega = {
            primary = true;
            remote = {
              type = "google_calendar";
              passwordCommand = [ (pass "services/google-aerc") ];
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
