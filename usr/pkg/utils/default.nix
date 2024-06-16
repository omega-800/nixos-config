{ usr, ... }: {
  imports = [
    ./utils.nix
    ./sxhkd.nix
    ./dunst.nix
    ./fzf.nix
  ] ++ (if usr.wmType == "x11" then [ ./sxhkd.nix ] else [ ./swhkd.nix ]);
}
