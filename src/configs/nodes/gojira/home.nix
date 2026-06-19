{lib, ...}: {
u.user.nixvim.enable = lib.mkForce false;
u.user.alacritty.enable = lib.mkForce false;
u.utils.rofi.enable = true;
u.net.qutebrowser.enable = true;
}
