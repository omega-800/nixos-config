{ pkgs, inputs, ... }: { home.packages = with pkgs; [ inputs.omega-st ]; }
