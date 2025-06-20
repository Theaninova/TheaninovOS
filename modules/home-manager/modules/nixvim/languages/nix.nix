{
  lib,
  pkgs,
  hostname,
  config,
  ...
}:
let
  cfg = config.presets.languages.nix;
in
{
  options.presets.languages.nix = {
    enable = lib.mkEnableOption "Nix";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
      lsp.servers = {
        nixd = {
          enable = true;
          settings = {
            nixpkgs.expr = # nix
              "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
            formatting.command = [ "nixfmt" ];
            options = {
              nixos.expr = # nix
                "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options";
              home-manager.expr = # nix
                "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []";
            };
          };
        };
        nil_ls = {
          enable = false;
          settings = {
            formatting.command = [ "nixfmt" ];
            nix = {
              maxMemoryMB = 8192;
              flake.autoEvalInputs = true;
            };
          };
        };
      };
    };
    extraPackages = [ pkgs.nixfmt-rfc-style ];
  };
}
