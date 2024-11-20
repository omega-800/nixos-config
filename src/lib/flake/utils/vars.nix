rec {
  CONFIGS = {
    homeConfigurations = "home";
    nixosConfigurations = "nixos";
    nixOnDroidConfigurations = "droid";
    systemConfigs = "system";
    omega = "omega";
  };
  PATHS = rec {
    ROOT = ../../../../.;
    SRC = ROOT + /src;
    MODULES = SRC + /modules;
    M_HOME = MODULES + /${CONFIGS.homeConfigurations};
    M_NIXOS = MODULES + /${CONFIGS.nixosConfigurations};
    M_DROID = MODULES + /${CONFIGS.nixOnDroidConfigurations};
    M_SYSTEM = MODULES + /${CONFIGS.systemConfigs};
    M_OMEGA = MODULES + /${CONFIGS.omega};
    LIBS = SRC + /lib;
    CONFIG = SRC + /configs;
    NODES = CONFIG + /nodes;
    PROFILES = CONFIG + /profiles;
    SHELLS = SRC + /shells;
    SECRETS = SRC + /secrets;
    PACKAGES = SRC + /pkgs;
    APPS = SRC + /apps;
    THEMES = SRC + /themes;
    CHECKS = SRC + /checks;
  };
  SYSTEMS = [
    "x86_64-linux"
    # "i686-linux"
    "aarch64-linux"
  ];
}
