{ shellInitExtra }: { pkgs, ... }: { home.packages = with pkgs; [ dash ]; }
