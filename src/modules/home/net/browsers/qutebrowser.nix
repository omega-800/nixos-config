{
  usr,
  globals,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    stringToCharacters
    nameValuePair
    replaceString
    removePrefix
    listToAttrs
    filterAttrs
    mapAttrs'
    mkOption
    elemAt
    types
    mkIf
    ;
  cfg = config.u.net.qutebrowser;
  userscripts = {
    "dig" = ''
      TEMP_FILE="$(mktemp --suffix .html)"
      dig "$QUTE_URL" > "$TEMP_FILE"
    '';
    "nslookup" = ''
      TEMP_FILE="$(mktemp --suffix .html)"
      nslookup "$QUTE_URL" > "$TEMP_FILE"
    '';
    "qr" = ''
      TEMP_FILE="$(mktemp --suffix .png)"
      ${pkgs.qrencode}/bin/qrencode -t PNG -o "$TEMP_FILE" -s 10 "$QUTE_URL"
    '';
    "linkdl" = ''
      for link in "$(awk -F'"' '/<a / {for (i=1; i<=NF; i++) if ($i ~ /href=/) print $(i+1)}' "$QUTE_HTML")"; do 
        if [[ "$link" == http* ]]; then 
          curl -O "$link"
        else
          curl -O "$QUTE_URL$link"
        fi
      done
    '';
  };
in
{
  options.u.net.qutebrowser.enable = mkOption {
    type = types.bool;
    default = (config.u.net.enable && !usr.minimal) || usr.browser == "qutebrowser";
  };
  config = mkIf cfg.enable {
    xdg.configFile = mapAttrs' (
      n: v:
      nameValuePair "qutebrowser/userscripts/${n}" {
        executable = true;
        text = ''
          #!/bin/sh

          ${v}
          echo "open -t file://$TEMP_FILE" >> "$QUTE_FIFO"
        '';
      }
    ) userscripts;
    programs.qutebrowser = {
      enable = true;
      package = pkgs.nixGL pkgs.qutebrowser;
      searchEngines =
        mapAttrs'
          (
            _: v:
            nameValuePair (removePrefix "@" (elemAt v.definedAliases 0)) (
              replaceString "{searchTerms}" "{}" (elemAt v.urls 0).template
            )
          )
          (
            filterAttrs (
              _: v: v ? definedAliases && v ? urls
            ) config.programs.firefox.profiles.${usr.username}.search.engines
          );
      keyBindings = {
        normal =
          {
            "xs" = "config-cycle statusbar.show always never";
            "xt" = "config-cycle tabs.show always never";
            "xx" = "config-cycle tabs.show always never;; config-cycle statusbar.show always never";
            "zp" = "spawn --userscript qute-pass";
            "zm" = "spawn --userscript dmenu_qutebrowser";
            "zf" = "spawn --userscript openfeeds";
            "zr" = "spawn --userscript readability";
            ",m" = "spawn mpv {url}";
            ",M" = "hint links spawn mpv {hint-url}";
            # generate qr code
            ",qr" = "jseval open('https://api.qrserver.com/v1/create-qr-code/?data=' + encodeURIComponent(location.href));";
            # shorten url
            # ",su" = "jseval (() => location = 'https://zzb.bz/bookmark/?url='+encodeURIComponent(window.location.href))()";
            # built with
            ",bw" = "jseval window.open('http://builtwith.com/?'+location.host)";
            # show links on webpage
            ",sl" = ''jseval (()=>{ var lks = document.querySelectorAll('a[href]'); var out = ""; lks.forEach((lk) => out += lk.href + '\\n'); if(out){ var ta = document.createElement('textarea'); ta.value = out; document.body.appendChild(ta); ta.select(); try { document.execCommand('copy'); alert('Links copied to clipboard:\\n\\n' + out); } catch (err) { alert('Failed to copy links: ' + err + '\\n\\n' + out); } document.body.removeChild(ta); } else { alert('No links found.'); } })();'';
            # show fonts on hover
            ",ft" = "jseval ((function(d) { var e = d.createElement('script'); e.setAttribute('type', 'text/javascript'); e.setAttribute('charset', 'UTF-8'); e.setAttribute('src', '//www.typesample.com/assets/typesample.js?r=' + Math.random() * 99999999); d.body.appendChild(e) })(document))";
            # is website down
            ",id" = "jseval open('https://downforeveryoneorjustme.com/' + location.hostname)";
            # pagespeed
            ",ps" = "jseval open('https://developers.google.com/speed/pagespeed/insights/?url='+encodeURI(window.location))";
          }
          // (mapAttrs' (
            n: v:
            nameValuePair "e${n}" "jseval x=escape(getSelection());if(!x)void(x=prompt('Term: '));if(x)void(open('${
              replaceString "{}" "'+escape(x)+'" v
            }'))"
          ) config.programs.qutebrowser.searchEngines)
          // (mapAttrs' (
            n: _: nameValuePair "z${elemAt (stringToCharacters n) 0}" "spawn --userscript ${n}"
          ) userscripts);
      };
      settings = {
        auto_save.session = true;
        content = {
          default_encoding = "utf-8";
          pdfjs = true;
          autoplay = false;
          blocking = {
            adblock.lists = [
              "https://easylist.to/easylist/easylist.txt"
              "https://easylist.to/easylist/easyprivacy.txt"
            ];
            enabled = true;
            method = "both";
          };
          cookies.accept = "no-3rdparty";
          geolocation = false;
          headers.do_not_track = true;
          # javascript.clipboard = "none";
          notifications.enabled = true;
          prefers_reduced_motion = true;
        };
        downloads.location = {
          directory = globals.envVars.XDG_DOWNLOAD_DIR;
          prompt = true;
          remember = true;
          suggestion = "both";
        };
        input.insert_mode = {
          auto_enter = true;
          auto_load = true;
          leave_on_load = true;
        };
        colors.webpage = {
          preferred_color_scheme = "dark";
          darkmode.enabled = true;
        };
        session.lazy_restore = false;
        statusbar = {
          position = "bottom";
          show = "always";
          widgets = [
            "keypress"
            "search_match"
            "url"
            "scroll"
            "history"
            "tabs"
            "progress"
          ];
        };
        tabs = {
          background = true;
          position = "left";
          show = "always";
          show_switching_delay = 800;
          title = {
            format = "{audio}{index}: {current_title}";
            format_pinned = "{index}";
          };
          undo_stack_size = 100;
        };
        url = {
          default_page = "https://start.duckduckgo.com/";
          searchengines = {
            # "DEFAULT" = "https://duckduckgo.com/?q={}";
          };
          start_pages = [ "https://start.duckduckgo.com" ];
        };
        window.title_format = "{perc}{current_title}";
      };
      perDomainSettings =
        {
          # "outlook.com"
        }
        // (listToAttrs (
          map
            (name: {
              inherit name;
              value.colors.webpage.darkmode.enabled = false;
            })
            [
              "nandgame.com"
              "academy.ripe.net"
              "ostch-my.sharepoint.com"
              "gaia.cs.umass.edu"
            ]
        )) // (listToAttrs (map 
          (name: {
            inherit name;
            value.content.register_protocol_handler = false;
          })
          [
            "gmail.com"
            "mail.google.com"
            "mail.proton.me"
            "outlook.office.com"
          ]
        ));
      quickmarks = {
        y = "https://www.youtube.com";
        osm = "https://www.openstreetmap.org";
        r = "https://www.reddit.com";
        g = "https://github.com";
        gl = "https://gitlab.com";
        ni = "https://nixos.org/manual/nixos/stable/index.html#ch-installation";
        dm = "https://www.desmos.com/calculator";
        "4c" = "https://4chan.org";
      };
      greasemonkey = [
        # HTML5 Video Playing Tools
        (pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/30545/HTML5%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE%E5%B7%A5%E5%85%B7.user.js";
          sha256 = "sha256-LQEaLMsKQKS47MScYcr3ubdmI0VnvqZQq0YxOUrZ4DU=";
        })
        # youtube-adb
        (pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/459541/YouTube%E5%8E%BB%E5%B9%BF%E5%91%8A.user.js";
          sha256 = "sha256-l1jSu6wD8/77wf5TT9apxvy+6B+9ywVm6pmMkhM6Ex8=";
        })
        # Bypass paywalls for scientific documents
        (pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/35521/Bypass%20paywalls%20for%20scientific%20documents.user.js";
          sha256 = "sha256-AfnLiQl6JaaPOz4mn9K/47HDDwBGxKR+dGkaRzifl/Q=";
        })
        # Don't track me google
        (pkgs.fetchurl {
          url = "https://update.greasyfork.org/scripts/428243/Don%27t%20track%20me%20Google.user.js";
          sha256 = "sha256-yEjBZprSjHyDRpd+TJ1vUsSYHrwLspQOztpKunBLPig=";
        })
        (pkgs.writeText "moodle-session-persist.user.js" ''
          // ==UserScript==
          // @name        Moodle Session Persist
          // @include     https://moodle.ost.org/*
          // @version     1
          // ==/UserScript==

          const prevKey = localStorage.getItem("ostMoodleSessionKey");
          const parts = `; $${document.cookie}`.split(`; MoodleSession=`);
          if (parts.length === 2) 
            localStorage.setItem("ostMoodleSessionKey", parts.pop().split(';').shift());
          else if (prevKey)
            document.cookie = `$${document.cookie}; MoodleSession=$${prevKey};`;
        '')
      ];
    };
  };
}
