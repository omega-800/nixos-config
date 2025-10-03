{
  globals,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (globals.styling) fonts colors;
  cfg = config.u.wm.river;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ sandbar ];
    xdg.configFile = {
      "river/bar" = {
        executable = true;
        text = ''
          #!/usr/bin/env sh

          FIFO="$XDG_RUNTIME_DIR/sandbar"
          [ -e "$FIFO" ] && rm -f "$FIFO"
          mkfifo "$FIFO"

          while cat "$FIFO"; do :; done | sandbar \
          	-font "${fonts.monospace.name}:size=${builtins.toString fonts.sizes.terminal}" \
          	-active-fg-color "#${colors.base05}" \
          	-active-bg-color "#${colors.base0D}" \
          	-inactive-fg-color "#${colors.base05}" \
          	-inactive-bg-color "#${colors.base03}" \
          	-urgent-fg-color "#${colors.base05}" \
          	-urgent-bg-color "#${colors.base08}" \
          	-title-fg-color "#${colors.base05}" \
          	-title-bg-color "#${colors.base00}"
        '';
      };
      "river/status" = {
        executable = true;
        text = ''
          #!/usr/bin/env sh

          cpu() {
          	cpu="$(grep -o "^[^ ]*" /proc/loadavg)"
          }

          memory() {
          	memory="$(free -h | sed -n "2s/\([^ ]* *\)\{2\}\([^ ]*\).*/\2/p")"
          }

          disk() {
          	disk="$(df -h | awk 'NR==2{print $4}')"
          }

          datetime() {
          	datetime="$(date "+%a %d %b %I:%M %P")"
          }

          bat() {
          	read -r bat_status </sys/class/power_supply/BAT0/status
          	read -r bat_capacity </sys/class/power_supply/BAT0/capacity
          	bat="$bat_status $bat_capacity%"
          }

          vol() {
          	vol="$([ "$(pamixer --get-mute)" = "false" ] && printf "%s%%" "$(pamixer --get-volume)" || printf '-')"
          }

          display() {
          	echo "all status [$memory $cpu $disk] [$bat] [$vol] [$datetime]" >"$FIFO"
          }

          printf "%s" "$$" > "$XDG_RUNTIME_DIR/status_pid"
          FIFO="$XDG_RUNTIME_DIR/sandbar"
          [ -e "$FIFO" ] || mkfifo "$FIFO"
          sec=0

          while true; do
          	sleep 1 &
          	wait && {
          		[ $((sec % 15)) -eq 0 ] && memory
          		[ $((sec % 15)) -eq 0 ] && cpu
          		[ $((sec % 15)) -eq 0 ] && disk
          		[ $((sec % 60)) -eq 0 ] && bat
          		[ $((sec % 5)) -eq 0 ] && vol
          		[ $((sec % 5)) -eq 0 ] && datetime

          		[ $((sec % 5)) -eq 0 ] && display

          		sec=$((sec + 1))
          	}
          done
        '';
      };
    };
  };
}
