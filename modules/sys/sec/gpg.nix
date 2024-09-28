{ pkgs, ... }: {
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-tty;
    settings = { default-cache-ttl = 600; };
  };
}
