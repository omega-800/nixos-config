{ sys, lib, ... }: {
  security = lib.mkIf sys.paranoid {
    auditd.enable = true;
    audit = {
      enable = true;
      rules = [ "-a exit,always -F arch=b64 -S execve" ];
    };
  };
}
