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
}
