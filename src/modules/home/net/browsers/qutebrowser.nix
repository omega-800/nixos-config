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
in
{
  options.u.net.qutebrowser.enable = mkOption {
    type = types.bool;
    default = (config.u.net.enable && !usr.minimal) || usr.browser == "qutebrowser";
  };
  config = mkIf cfg.enable {
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
        normal = {
          "xs" = "config-cycle statusbar.show always never";
          "xt" = "config-cycle tabs.show always never";
          "xx" = "config-cycle tabs.show always never;; config-cycle statusbar.show always never";
          ",m" = "spawn mpv {url}";
          ",M" = "hint links spawn mpv {hint-url}";
          # generate qr code
          ",qr" = "jseval open('https://api.qrserver.com/v1/create-qr-code/?data=' + encodeURIComponent(location.href));";
          # shorten url
          # ",su" = "jseval (() => location = 'https://zzb.bz/bookmark/?url='+encodeURIComponent(window.location.href))()";
          # built with
          ",bw" = "jseval window.open('http://builtwith.com/?'+location.host)";
          # show links on webpage
          # ",sl" = ''jseval (function () { str = ""; anchors = document.getElementsByTagName("a"); var all = []; str += "<table width='100%'>"; var k = 0; var listing = ""; var anchorTexts = ""; var linksAnchors = ""; for (i = 0; i < anchors.length; i++) { var anchorText = anchors[i].textContent; var anchorLink = anchors[i].href; var linkAnchor = ""; if ( anchorLink != "" && all.indexOf(anchorLink) == -1 && anchorText != "" && anchors[i].className != "gb_b") { all.push(anchorLink); listing += anchorLink + "\n"; anchorTexts += anchorText + "\n"; linkAnchor = anchorLink.replace(",", "%2C") + ",	" + anchorText.replace(",", ""); linksAnchors += linkAnchor + "\n"; k = k + 1; if (anchorText === undefined) anchorText = anchors[i].innerText; str += "<tr>"; str += "<td class='id'>" + k + "</td>"; str += "<td><a href=" + anchors[i].href + " target='_blank'>" + anchors[i].href + "</a></td>"; str += "<td>" + anchorText + "</td>"; str += "</tr>\n"; } } str += "</table><br/><br/><table width='100%'><tr><td width='55%'><h2>Links</h2><textarea rows=10 style='width:97%' readonly>"; str += listing; str += "</textarea></td><td width='45%'><h2>Anchors</h2><textarea rows=10 readonly>"; str += anchorTexts; str += "</textarea></td></tr></table><br/><br/><h2>All Data - CSV</h2><textarea rows=10 readonly>"; str += "Links, Anchors\n"; str += linksAnchors; str += "</textarea><br /> <br />"; with (window.open()) { document.write(str); document.close(); } })();'';
          # show fonts on hover
          ",ft" =
            "jseval ((function(d) { var e = d.createElement('script'); e.setAttribute('type', 'text/javascript'); e.setAttribute('charset', 'UTF-8'); e.setAttribute('src', '//www.typesample.com/assets/typesample.js?r=' + Math.random() * 99999999); d.body.appendChild(e) })(document))";
          # is website down
          ",id" = "jseval open('https://downforeveryoneorjustme.com/' + location.hostname)";
          # pagespeed
          ",ps" = "jseval open('https://developers.google.com/speed/pagespeed/insights/?url='+encodeURI(window.location))";
        }
        // (mapAttrs' (
          n: v:
          nameValuePair ",d${n}" "jseval x=escape(getSelection());if(!x)void(x=prompt('Term: '));if(x)void(open('${
            replaceString "{searchTerms}" "'+escape(x)+'" v
          }'))"
        ) config.programs.qutebrowser.searchEngines);
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
          javascript.clipboard = "none";
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
      perDomainSettings = {
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
