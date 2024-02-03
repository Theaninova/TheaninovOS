{pkgs}: {
  enable = true;
  package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      FirefoxHome = {
        Search = true;
        Pocket = false;
        Snippets = false;
        TopSites = true;
        Highlights = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };
  };
  profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    bookmarks = [
      {
        name = "Monkeytype";
        url = "https://monkeytype.com/";
      }
      {
        name = "YouTube";
        url = "https://youtube.com/";
      }
    ];
    search = {
      force = true;
      default = "Google";
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
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
        "NixOS Wiki" = {
          urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = ["@nw"];
        };
        "Wikipedia (en)".metaData.alias = "@wiki";
      };
    };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      ublacklist
      sponsorblock
      bitwarden
    ];
  };
}
