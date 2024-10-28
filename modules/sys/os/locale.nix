{ sys, ... }:
{
  i18n = {
    defaultLocale = sys.locale;
    extraLocaleSettings = {
      LC_ADDRESS = sys.locale;
      LC_IDENTIFICATION = sys.locale;
      LC_MEASUREMENT = sys.locale;
      LC_MONETARY = sys.locale;
      LC_NAME = sys.locale;
      LC_NUMERIC = sys.locale;
      LC_PAPER = sys.locale;
      LC_TELEPHONE = sys.locale;
      LC_TIME = sys.locale;
    };
  };
}
