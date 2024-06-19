{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.fancyfonts;
in {
  options.m.fancyfonts = {
    enable = mkEnableOption "enables fancyfonts";
  };

  config = mkIf cfg.enable {
  # Fonts are nice to have
  fonts.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [ "Inconsolata" "JetBrainsMono" ]; })
    powerline
    inconsolata
    inconsolata-nerdfont
    iosevka
    font-awesome
    ubuntu_font_family
    terminus_font
  ];
};

}
