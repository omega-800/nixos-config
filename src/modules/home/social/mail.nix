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
      # for microsoft o365
      home.packages = [ pkgs.oama ];
      xdg.configFile."oama/config.yaml" = {
      enable = true;
      force = true;
      text = ''
        encryption:
            tag: KEYRING

        services:
          microsoft:
            # client_id: 08162f7c-0fd2-4200-a84a-f25a4db0b584 # notsecret
            # client_secret: 'TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82' # notsecret
            client_id: 84992ecd-5239-426a-8013-b66401e8c778 # ost
            # client_secret: 'TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82' # ost
            auth_scope: https://outlook.office.com/IMAP.AccessAsUser.All
              https://outlook.office.com/SMTP.Send
              offline_access
            tenant: a6e70fa3-1c7a-4aa2-a25e-836eea52ca22
            prompt: select_account
            auth_endpoint: https://login.microsoftonline.com/a6e70fa3-1c7a-4aa2-a25e-836eea52ca22/oauth2/authorize
            redirect_uri: http://localhost:33473
      '';
    };

# https://login.microsoftonline.com/common/oauth2/nativeclient?client_id=84992ecd-5239-426a-8013-b66401e8c778&response_type=code&scope=https%3A%2F%2Foutlook.office.com%2FIMAP.AccessAsUser.All%20https%3A%2F%2Foutlook.office.com%2FSMTP.Send%20offline_access&login_hint=georgiy.shevoroshkin%40ost.ch&redirect_uri=http%3A%2F%2Flocalhost%3A46585&access_type&code_challenge=_E01sw32i7nqMxfyk8igu4VJ0fjEQ9d_vTbHjyccsXU&code_challenge_method=S256&state=3WB1Z56ow_0v7nwxaD94V2UmkKDRk3FySjYgutm81Ig&prompt=select_account
# https://login.microsoftonline.com/a6e70fa3-1c7a-4aa2-a25e-836eea52ca22/oauth2/authorize?client_id=84992ecd-5239-426a-8013-b66401e8c778&response_type=code&scope=https%3A%2F%2Foutlook.office.com%2FIMAP.AccessAsUser.All%20https%3A%2F%2Foutlook.office.com%2FSMTP.Send%20offline_access&login_hint=georgiy.shevoroshkin%40ost.ch&redirect_uri=http%3A%2F%2Flocalhost%3A46585&access_type&code_challenge=_E01sw32i7nqMxfyk8igu4VJ0fjEQ9d_vTbHjyccsXU&code_challenge_method=S256&state=3WB1Z56ow_0v7nwxaD94V2UmkKDRk3FySjYgutm81Ig&prompt=select_account
#
# http://localhost:33473/?code=1.AToAow_npnocokqiXoNu6lLKIryUX56k6HNOuL5jNkwp11MAAE86AA.BQABBAIAAAADAOz_BQD0_0V2b1N0c0FydGlmYWN0cwIAAAAAAN-Kmcd9m26QBldO1aEC_hOJnZAJCCzi5wfcZHUhbC_9a--fepM-UAX13-mwdHxQiOjzc4-To9a0aLLDVQG-wGF12Xvv6Mp7dgW5EC5wsHIfTC_FSZLeiYbK7rWQxHIz45PLaAKd4BaJE5SdOmfLZpdf0-jrKS0f22Bh0fvD86HuuNF9YS3a37lrTjFPDU0msJOCItYLmjjYiJfHHUSOq1JZhRRJyeBcChOqJKHKIqetlibZeR4djsNe-Ql0wK14rC60xYE7OVBLx2TbH4Q7FWqeyUAXqbO4UmFpjovCldJGpuwkKf_NrJWyALzz-8dcqPbWI8MoY8ZL_eltvF44zi87YSEI_DzEm-9TBwowMvdSeE8whXO8bjKuEaAzAtMOQqVL9AarlGg92z0i5fWsXpow550gEIrD6sCEjooVP68kWMRgdfmRF9xaHqpjlEMiOCE9RPyvaJYfFlsbN9WC3wPxIIzhCcf10vYyTtzRc4KeLpAKgWgpUQnBApOe3gTcpbOY_wf9L9HIsoX0Lg_pph2wUahAY5ahle6E52TQKhsx_TwfQaRYsuXhJHWs8sFm8C1FFUMrIC3DTOXj2370-LEmbQKEhMDUk4otrjuIn-3eZi98Nu1eSKl8WXx0qadRQGt-CbvsQovT3cQBC-nISYpO2xL22fnjjJV79jyEYUsog5CDsGJkpnIsoy8-Mb9uOfFvc37IhSnElfge694PN7jmOmzgJSHmlzbIImR1acCtKLzXKaAI7Tco9clKtYB_9E07PGazCKAkFEfPacYuASiWZYGCMh_1BKAg8_OuVo3hCTz1JjylR-ptetkRiEzWAiKpcTe40ljEF9IVBQc9xTTJOFRqe_a9hIDt0Q3yko6zy3gByPwa-BvuxhL6stB4Tf92BSlsVF0YADUupNHcu0x9X2vM1vNDBnF6TXCK-Jv4FH-rb_vGoN40rvOgZ_fAI83rE_hU0_Lzs9lT9QMqo6NO-6VGTgid4fRtrCq6v0at92dUMfYUERBxUdy4OqlFkxgo74WYBQ-sa7Iat7ZhD4_FpshG_uEAyaYhVWSnSrZIZpPgcO5esrtMHxlERTD0N8j3kx84rFpK5f5pVVXmMPmQ5QlwXJiC1CWyaY_NnNISD_KVZbLhnxCVM4bOtsCV8o78HTxm9QWYGgmKaCPbEEepqBsPGDMMDM3MP6qrBB_TaPrSJPmT9af2QUS0UxJw3rdgNe3aR64Vi_87oK6tiv2TqxU3rmp-X0wUX6eyU75Z2w0d-kTbZv5iDCYhPWPs2WOKMLq6kUBXvR2HRH0EtZFECDGG5YSNnxw&state=m6GKc4DHTOH3EvkSadwAVcc2UGnrcZ7YFWwGkdXFFS4&session_state=008c907a-0f9b-8b2b-fd65-c7abeb89387f
# https://login.microsoftonline.com/common/oauth2/v2.0/authorize?response_type=code&client_id=9e5f94bc-e8a4-4e73-b8be-63364c29d753&scope=https%3A%2F%2Foutlook.office.com%2FIMAP.AccessAsUser.All+https%3A%2F%2Foutlook.office.com%2FPOP.AccessAsUser.All+https%3A%2F%2Foutlook.office.com%2FSMTP.Send+offline_access&state=m6GKc4DHTOH3EvkSadwAVcc2UGnrcZ7YFWwGkdXFFS4&login_hint=georgiy.shevoroshkin%40ost.ch&redirect_uri=http%3A%2F%2Flocalhost%3A33473

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
      thunderbird = {
        enable = true;
      };
    };
  };
}
