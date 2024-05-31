{ ... }: {
  services.sxhkd = {
    enable = true;
    extraConfig = builtins.readFile ./sxhkdrc;
  };
}
