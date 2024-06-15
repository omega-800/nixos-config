{ config, ... }: {
  i18n = {
    defaultLocale = config.c.sys.locale;
    extraLocaleSettings = {
      LC_ADDRESS = config.c.sys.locale;
      LC_IDENTIFICATION = config.c.sys.locale;
      LC_MEASUREMENT = config.c.sys.locale;
      LC_MONETARY = config.c.sys.locale;
      LC_NAME = config.c.sys.locale;
      LC_NUMERIC = config.c.sys.locale;
      LC_PAPER = config.c.sys.locale;
      LC_TELEPHONE = config.c.sys.locale;
      LC_TIME = config.c.sys.locale;
    };
  };
  console = {
    font = config.c.sys.font;
    packages = [ config.c.sys.fontPkg ];
    keyMap = config.c.sys.kbLayout;
  };
  fonts.fontDir.enable = true;
}
