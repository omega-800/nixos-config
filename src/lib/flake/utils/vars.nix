{
  CONFIGS = {
    homeConfigurations = "home";
    nixosConfigurations = "nixos";
    nixOnDroidConfigurations = "droid";
    systemConfigs = "system";
    omega = "config";
  };
  PATHS = {
    ROOT = ../../../../.;
    MODULES = ../../../modules;
    LIBS = ../../.;
    NODES = ../../../hosts/nodes;
    PROFILES = ../../../hosts/profiles;
    SHELLS = ../../../shells;
    SECRETS = ../../../secrets;
    PACKAGES = ../../../pkgs;
    APPS = ../../../apps;
    THEMES = ../../../themes;
  };
  SYSTEMS = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
