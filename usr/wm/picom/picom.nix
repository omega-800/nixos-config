{ pkgs, systemSettings, ... }:

{
  config = mkIf systemSettings.genericLinux {
    home.packages = with pkgs; 
      picom
    ];

    home.file.".config/picom/picom.conf".source = ./picom.conf;
  };
}
