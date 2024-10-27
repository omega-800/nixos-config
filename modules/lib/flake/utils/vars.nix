{
  CONFIGS = {
    homeConfigurations = "home";
    nixosConfigurations = "configuration";
    nixOnDroidConfigurations = "droid";
    #TODO: change
    systemConfigs = "configuration";
  };
  PATHS = {
    ROOT = ../../../../.;
    MODULES = ../../../.;
    LIBS = ../../.;
    HOSTS = ../../../hosts;
  };
  SYSTEMS = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
