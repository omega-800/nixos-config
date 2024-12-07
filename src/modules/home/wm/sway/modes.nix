{
  usr,
  pkgs,
  config,
  ...
}:
{
  resize = {
    "h" = "resize shrink width 10 px";
    "j" = "resize grow height 10 px";
    "k" = "resize shrink height 10 px";
    "l" = "resize grow width 10 px";
    "Left" = "resize shrink width 10 px";
    "Down" = "resize grow height 10 px";
    "Up" = "resize shrink height 10 px";
    "Right" = "resize grow width 10 px";
    "Escape" = "mode default";
    "Return" = "mode default";
  };
}
