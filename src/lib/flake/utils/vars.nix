rec {
  CONFIGS = {
    homeConfigurations = "home";
    nixosConfigurations = "nixos";
    nixOnDroidConfigurations = "droid";
    systemConfigs = "system";
    omega = "config";
  };
  PATHS = rec {
    ROOT = ../../../../.;
    SRC = ROOT + /src;
    MODULES = SRC + /modules;
    M_HOME = MODULES + /${CONFIGS.homeConfigurations};
    M_NIXOS = MODULES + /${CONFIGS.nixosConfigurations};
    M_DROID = MODULES + /${CONFIGS.nixOnDroidConfigurations};
    M_SYSTEM = MODULES + /${CONFIGS.systemConfigs};
    LIBS = SRC + /lib;
    CONFIG = SRC + /configs;
    NODES = CONFIG + /nodes;
    PROFILES = CONFIG + /profiles;
    SHELLS = SRC + /shells;
    SECRETS = SRC + /secrets;
    PACKAGES = SRC + /pkgs;
    APPS = SRC + /apps;
    THEMES = SRC + /themes;
  };
  SYSTEMS = [
    "x86_64-linux"
    # "i686-linux"
    "aarch64-linux"
  ];
}
