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
          ",c" = "spawn --userscript moodle-session-persist";
        };
      };
      settings = {
        auto_save.session = true;
        content = {
          default_encoding = "utf-8";
          geolocation = false;
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
        "nandgame.com".colors.webpage.darkmode.enabled = false;
        # "outlook.com"
      };
      quickmarks = {
        y = "https://www.youtube.com";
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
