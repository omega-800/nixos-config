{
  globals,
  usr,
  sys,
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    optionals
    readFile
    ;
  cfg = config.u.net.firefox;
in
{
  #TODO: check this one out https://github.com/schizofox/schizofox/tree/main
  options.u.net.firefox.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable && !usr.minimal;
  };
  config = mkIf cfg.enable {
    home.sessionVariables = mkIf (usr.wmType == "wayland") { MOZ_ENABLE_WAYLAND = 1; };
    programs.firefox = {
      enable = true;
      #package = pkgs.librewolf;
      #package = pkgs.firefox-devedition-unwrapped;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DefaultDownloadDirectory = globals.envVars.XDG_DOWNLOAD_DIR;
        #DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        #DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        #SearchBar = "unified"; # alternative: "separate"
      };
      profiles.${usr.username} = {
        # FIXME: search bar doesn't autohide
        # userChrome = readFile ./userChrome.css;
        extensions.packages =
          #with inputs.firefox-addons.packages.${sys.system};
          with pkgs.nur.repos.rycee.firefox-addons;
          [
            ublock-origin
            darkreader
            vimium
          ]
          ++ (with pkgs.nur.repos.rycee.firefox-addons; [
            cookie-autodelete
            i-dont-care-about-cookies
            privacy-badger
          ]
          /*
            ++ (optionals usr.extraBloat (
              with pkgs.nur.repos.rycee.firefox-addons;
              [
                link-cleaner
                decentraleyes
                anchors-reveal
                reddit-enhancement-suite
                # tree-style-tab
              ]
              ++ (with inputs.firefox-addons.packages.${sys.system}; [
                multi-account-containers
                youtube-shorts-block
                # passff
                sponsorblock
                #firenvim
                #bitwarden
              ])
            ))
          */
          );

        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";

          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@n" ];
            };
            "NixOS install guide" = {
              urls = [
                {
                  template = "https://nixos.org/manual/nixos/stable/index.html#ch-installation";
                }
              ];
              definedAliases = [ "@ni" ];
            };
            "NixOS wiki" = {
              urls = [
                {
                  template = "https://wiki.nixos.org/index.php?search={searchTerms}";
                }
              ];
              icon = "https://wiki.nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "noogle" = {
              urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
              icon = "https://wiki.nixos.org/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@ng" ];
            };
            "youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results?search_query={searchTerms}";
                }
              ];
              definedAliases = [ "@y" ];
            };
            "reddit" = {
              urls = [
                {
                  template = "https://www.reddit.com/search/?q={searchTerms}";
                }
              ];
              definedAliases = [ "@r" ];
            };
            "subreddit" = {
              urls = [ { template = "https://www.reddit.com/r/{searchTerms}/"; } ];
              definedAliases = [ "@rr" ];
            };
            "github" = {
              urls = [
                {
                  template = "https://github.com/search?q={searchTerms}&type=repositories";
                }
              ];
              definedAliases = [ "@gh" ];
            };
            "github link" = {
              urls = [ { template = "https://github.com/{searchTerms}"; } ];
              definedAliases = [ "@ghl" ];
            };
            "github self" = {
              urls = [
                {
                  template = "https://github.com/${usr.devName}/{searchTerms}";
                }
              ];
              definedAliases = [ "@ghs" ];
            };

            "bing".metaData.hidden = true;
            "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };

        settings = {
          "app.shield.optoutstudies.enabled" = false;
          "browser.tabs.warnOnClose" = true;
          "browser.startup.page" = 3;
          "browser.disableResetPrompt" = true;
          "browser.download.dir" = globals.envVars.XDG_DOWNLOAD_DIR;
          "browser.download.panel.shown" = true;
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.placeholderName.private" = "DuckDuckGo";
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage" = "https://start.duckduckgo.com";
          "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","downloads-button","library-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":18,"newElementCount":4}'';
          "dom.security.https_only_mode" = true;
          "identity.fxaccounts.enabled" = false;
          "privacy.trackingprotection.enabled" = true;
          "signon.rememberSignons" = false;
          "extensions.pocket.enabled" = false;
          "extensions.screenshots.disabled" = true;
          "browser.topsites.contile.enabled" = false;
          "browser.formfill.enable" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.system.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        };
      };
    };
  };
}
