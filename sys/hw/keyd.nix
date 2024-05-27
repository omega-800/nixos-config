{ pkgs, ... }: {
  systemd.services.keyd = {
    enable = true;
    description = "key remapping daemon";
    wantedBy = [ "sysinit.target" ];
    requires = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
    environment.KEYD_CONFIG_DIR = pkgs.writeTextDir "keymap.conf"  ''
      [ids]
      *
      [main]
      backspace = capslock
      capslock = backspace
    '';
    serviceConfig.ExecStart = "${pkgs.keyd}/bin/keyd";
  }
}
