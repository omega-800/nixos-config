{ sys, lib, ... }: {
  #TODO: implement? write my own? 
  security.apparmor = lib.mkIf sys.hardened {
    enable = true;
    includes = { };
    policies = { };
    killUnconfinedConfinables = true;
  };
}
